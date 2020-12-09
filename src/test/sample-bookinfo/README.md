# Sample Bookinfo

This example deploys a sample application composed of four separate microservices used to demonstrate various Istio features.

The application displays information about a book, similar to a single catalog entry of an online book store. Displayed on the page is a description of the book, book details (ISBN, number of pages, and so on), and a few book reviews.

## Install

```bash
helm install test/sample-bookinfo
```

## Key Notes

[Application Requirements](https://github.com/kubernetes-sigs/application)

```bash
app.kubernetes.io/name=<applicationName>,app.kubernetes.io/version=v1
```

[Isito Requirements](https://istio.io/latest/docs/ops/deployment/requirements/)

```plain
# deployment
app=<servicename>,version=v1

# service
app=<servicename>
```
