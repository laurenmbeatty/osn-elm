# Demo of Elm for Open Source North

This is an application I created with Elm, integrating the Unsplash API, and using fun CSS (grid, clip-path, etc.),

## Getting started

Install many things:

```
$ npm install -g elm elm-test elm-css elm-live@2.6.1 elm-format@exp
```

Then install the application-specific elm packages:

```
$ elm-package install --yes
```

Finally, get your application up and running:  

```
$ elm-live PhotoGallery.elm --open --output=elm.js
```
You will need to create an account with Unsplash API and secure a clientID and insert in the appropriate place in PhotoGallery.elm (just look for a TODO).
