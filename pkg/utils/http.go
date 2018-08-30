package utils

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
	"strings"
)

// Client struct type
type Client struct {
	Client *http.Client
	Addr   string
}

// NewClient returns a client at the specified url.
func NewClient(uri string, cli *http.Client) *Client {
	return &Client{cli, strings.TrimSuffix(uri, "/")}
}

// Get helper function for making an http GET request.
func (c *Client) Get(rawurl string, out interface{}) error {
	return c.Do(rawurl, "GET", nil, out)
}

// Post helper function for making an http POST request.
func (c *Client) Post(rawurl string, in, out interface{}) error {
	return c.Do(rawurl, "POST", in, out)
}

// Put helper function for making an http PUT request.
func (c *Client) Put(rawurl string, in, out interface{}) error {
	return c.Do(rawurl, "PUT", in, out)
}

// Patch elper function for making an http PATCH request.
func (c *Client) Patch(rawurl string, in, out interface{}) error {
	return c.Do(rawurl, "PATCH", in, out)
}

// Delete helper function for making an http DELETE request.
func (c *Client) Delete(rawurl string) error {
	return c.Do(rawurl, "DELETE", nil, nil)
}

// Do helper function to make an http request
func (c *Client) Do(rawurl, method string, in, out interface{}) error {
	body, err := c.Open(rawurl, method, in, out)
	if err != nil {
		return err
	}
	defer body.Close()
	if out != nil {
		return json.NewDecoder(body).Decode(out)
	}
	return nil
}

// Open helper function to open an http request
func (c *Client) Open(rawurl, method string, in, out interface{}) (io.ReadCloser, error) {
	uri, err := url.Parse(rawurl)
	if err != nil {
		return nil, err
	}
	req, err := http.NewRequest(method, uri.String(), nil)
	if err != nil {
		return nil, err
	}
	if in != nil {
		decoded, derr := json.Marshal(in)
		if derr != nil {
			return nil, derr
		}
		buf := bytes.NewBuffer(decoded)
		req.Body = ioutil.NopCloser(buf)
		req.ContentLength = int64(len(decoded))
		req.Header.Set("Content-Length", strconv.Itoa(len(decoded)))
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := c.Client.Do(req)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode > http.StatusPartialContent {
		defer resp.Body.Close()
		out, _ := ioutil.ReadAll(resp.Body)
		return nil, fmt.Errorf("client error %d: %s", resp.StatusCode, string(out))
	}
	return resp.Body, nil
}

// mapValues converts a map to url.Values
func mapValues(params map[string]string) url.Values {
	values := url.Values{}
	for key, val := range params {
		values.Add(key, val)
	}
	return values
}
