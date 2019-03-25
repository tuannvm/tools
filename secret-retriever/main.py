import hvac
import os
import optparse
# TODO:
# 1. make it become a command line
# 2. Make it configurable


def vault_client():
    client = hvac.Client(os.environ['VAULT_ENDPOINT'])
    client.auth_approle(os.environ['VAULT_ROLE_ID'],
                        os.environ['VAULT_SECRET_ID'])
    return client


def write_secrets_to_file(client, secret_path, file_path):
    secrets = client.read(secret_path)["data"]

    with open(file_path, 'w') as file:
        for k, v in secrets.items():
            file.write(f'{k}="{v}"\n')


def main():
    parser = optparse.OptionParser('Usage: python script.py' +
                                   ' -s <secret-path>' +
                                   ' -d <file-path>')

    parser.add_option('-s', dest='secret_path', type='string',
                      help='specify vault secret path')
    parser.add_option('-d', dest='file_path', type='string',
                      help='specify file path to store secrets`')
    (options, args) = parser.parse_args()
    secret_path = options.secret_path
    file_path = options.file_path
    if secret_path is None or file_path is None:
        print(parser.usage)
        exit(0)
    client = vault_client()
    write_secrets_to_file(client, secret_path, file_path)


if __name__ == "__main__":
    main()
