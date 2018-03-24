# global option
BIN_PATH := scripts
PLATFORM := darwin_amd64
SERVICE_NAME := nginx
FILTER := | grep -v "|" | sed -e 's/^[ \t]*//'

# vault option
VAULT_VERSION := 0.9.6
VAULT_PATH := $(BIN_PATH)/vault
VAULT_OUTPUT_FORMAT := yaml
VAULT_KEY_PATH := config

# helm option
HELM_VERSION := v2.8.2
HELM_PATH := $(BIN_PATH)/helm
CHART_NAME := hb-charts/$(SERVICE_NAME)
CHART_VERSION := 2.0.1
CHART_REPOSITORY := https://kubernetes-charts.storage.googleapis.com
TILLER_NAMESPACE := default


# kubectl option
KUBE_VERSION := v1.9.0
KUBE_PATH := $(BIN_PATH)/kubectl
KUBE_NAMESPACE := default
KUBE_AUTH_URL := https://dex.coreos.com

help:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


$(BIN_PATH)/vault:
	@ mkdir -p $@
	@ curl -L https://releases.hashicorp.com/vault/$(VAULT_VERSION)/vault_$(VAULT_VERSION)_$(PLATFORM).zip | bsdtar -xvf- -C $(BIN_PATH)

$(BIN_PATH)/kubectl:
	@ mkdir -p $@
	@ rm -r $@
	@ curl -S -L -f https://storage.googleapis.com/kubernetes-release/release/$(KUBE_VERSION)/bin/$(subst _,/,$(PLATFORM))/kubectl -o $@
	@ chmod +x $@

$(BIN_PATH)/helm:
	@ mkdir -p $@
	@ curl -L https://storage.googleapis.com/kubernetes-helm/helm-$(HELM_VERSION)-$(subst _,-,$(PLATFORM)).tar.gz | tar -xzC $(BIN_PATH) && \
	rm -r $(BIN_PATH)/helm && \
	mv $(BIN_PATH)/$(subst _,-,$(PLATFORM))/helm $(BIN_PATH)/ && \
	rm -rf $(BIN_PATH)/$(subst _,-,$(PLATFORM))

read-secret: $(VAULT_PATH) check-env ## Retrieve secret from vault. Usage: ENVIRONMENT=(staging|production) make read-secret
	@ echo "Retrieve secrets ..."
ifeq ($(ENVIRONMENT), production)
	@ $(VAULT_PATH) read -format=$(VAULT_OUTPUT_FORMAT) -field=$(VAULT_KEY_PATH) secret/$(ENVIRONMENT)/$(SERVICE_NAME) $(FILTER) > .env-$(ENVIRONMENT)
else
	@ $(VAULT_PATH) read -format=$(VAULT_OUTPUT_FORMAT) -field=$(VAULT_KEY_PATH) secret/$(ENVIRONMENT)/$(SERVICE_NAME)-$(ENVIRONMENT) $(FILTER) > .env-$(ENVIRONMENT)
endif
	@ echo "Retrieve successfully! File .env-$(ENVIRONMENT) is saved"
	@ echo "Now make change to .env-$(ENVIRONMENT), and run 'env ENVIRONMENT=$(ENVIRONMENT) make write-secret' to update secret on vault"

write-secret: $(VAULT_PATH) check-env ## After edit, rewrite secret to vault. Usage: ENVIRONMENT=(staging|production) make write-secret
	@ echo "Write secrets ..."
ifeq ($(ENVIRONMENT), production)
	@ $(VAULT_PATH) write secret/$(ENVIRONMENT)/$(SERVICE_NAME) $(VAULT_KEY_PATH)=@.env-$(ENVIRONMENT)
else
	@ $(VAULT_PATH) write secret/$(ENVIRONMENT)/$(SERVICE_NAME)-$(ENVIRONMENT) $(VAULT_KEY_PATH)=@.env-$(ENVIRONMENT)
endif
	@ echo "Now go ahead and do rolling upgrade by running 'env ENVIRONMENT=$(ENVIRONMENT) make helm-update'"

helm-init: $(HELM_PATH)
	@ echo "*** Make sure you're inside ACTIVE VPN conection! ***"
	@ echo "*****************************************************"
	@ $(HELM_PATH) init --client-only
	@ $(HELM_PATH) repo add hb-charts $(CHART_REPOSITORY)
	@ $(HELM_PATH) repo update

kubectl-switch-namespace: $(KUBE_PATH) ## Switch kubernetes namespace. Usage: make kubectl-switch-namespace
	@ echo "Make sure to obtain necessary Kubernetes token via $(KUBE_AUTH_URL)"
	@ echo "Switching context ..."
	@ $(KUBE_PATH) config set-context $$($(KUBE_PATH) config current-context) --namespace=$(KUBE_NAMESPACE)

kubectl-get-contexts: $(KUBE_PATH) ## Show availables kubernetes contexts. Usage: make kubectl-get-contexts
	@ $(KUBE_PATH) config get-contexts

kubectl-use-context: $(KUBE_PATH) ## Switch to specific kubernetes cluster. Usage: make kubectl-use-context context=<CONTEXT>
	@ $(KUBE_PATH) config use-context

helm-update: helm-init kubectl-switch-namespace check-env ## Force rolling update to apply new secrets. Usage: ENVIRONMENT=(staging|production) make helm-update
	@ echo "*** Updating  ... ***"
ifeq ($(ENVIRONMENT), production)
	$(HELM_PATH) upgrade --install --tiller-namespace $(TILLER_NAMESPACE) $(SERVICE_NAME) --version $(CHART_VERSION) $(CHART_NAME) --set config.last-config-change=$$(date +%Y%m%d-%H%M%S) --reuse-values
else
	$(HELM_PATH) upgrade --install --tiller-namespace $(TILLER_NAMESPACE) $(SERVICE_NAME)-$(ENVIRONMENT) --version $(CHART_VERSION) $(CHART_NAME) --set config.last-config-change=$$(date +%Y%m%d-%H%M%S) --reuse-values
endif

helm-history: kubectl-switch-namespace check-env ## Show release history. Usage: ENVIRONMENT=(staging|production) make helm-history
ifeq ($(ENVIRONMENT), production)
	$(HELM_PATH) --tiller-namespace $(TILLER_NAMESPACE) history $(SERVICE_NAME)
else
	$(HELM_PATH) --tiller-namespace $(TILLER_NAMESPACE) history $(SERVICE_NAME)-$(ENVIRONMENT)
endif

helm-rollback: kubectl-switch-namespace check-env ## Rollback to previous revision. Usage: ENVIRONMENT=(staging|production) make helm-rollback revision=<revision-number>
ifeq ($(ENVIRONMENT), production)
	$(HELM_PATH) --tiller-namespace $(TILLER_NAMESPACE) rollback $(SERVICE_NAME) $(revision)
else
	$(HELM_PATH) --tiller-namespace $(TILLER_NAMESPACE) rollback $(SERVICE_NAME)-$(ENVIRONMENT) $(revision)
endif

clean:
	rm -rf $(BIN_PATH)/{vault,helm,kubectl}

check-env:
ifndef ENVIRONMENT # no whitespace !!!
	$(error ENVIRONMENT is undefined)
endif

.PHONY: help check-env read-secret helm-update kubectl-switch-namespace helm-init write-secret
