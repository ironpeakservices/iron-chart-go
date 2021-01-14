# iron-chart-go

Example repository to develop a Go webservice and automatically publish to a Helm chart using security best practices on GitHub.
Let's develop in Kubernetes too. Fork me!

This recompiles your Go code when changes are detected, makes the delve Go debugger available and packs everything in a nice secure container.

## Development

```shell
# this deploys as a helm chart to your default kubernetes context
% make

# see the pods being created
% kubectl get pods

# now edit the website source code to see it reload live!
```

## Debugging

```shell
# see what's holding up the Pod
% kubectl logs <the-pod-id>

# try to remove and redeploy the Chart
% make clean build up logs
```

## Releasing

1. Push your changes to `dev` or a feature branch.
2. Open a Pull Request and see your changes get linted, built and tested!
3. Merge to publish a new Helm Chart release.

## Usage

```shell
# first add our helm repository
# provide a GitHub token if it's private
% helm repo add ironchartgo https://${GITHUB_TOKEN}@raw.githubusercontent.com/ironpeakservices/iron-chart-go/helmrepo/
"ironchartgo" has been added to your repositories

# now let's install our Chart from our repository
% helm install mychart ironchartgo/iron-chart-go
```

## Forking

1. Fork the repository
2. Change all references to ironpeakservices, hazcod or this repository.
3. Provide your GitHub secret names in `.github/workflows/`.
4. Create a `helmrepo` branch which will host your Chart tarballs.
