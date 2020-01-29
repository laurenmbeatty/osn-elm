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

Create an `Auth.elm` file in the root of the project. It should look like this:

```
module Auth exposing (token)


token : String
token =
    "YourUnsplashAPITokenGoesHere"
```

Finally, get your application up and running:

```
$ elm-live PhotoGallery.elm --open -- --output=elm.js
```

Navigate to [http://localhost:8000/index.html](http://localhost:8000/index.html) to see the application in action. As you're editing, the terminal will help guide you with helpful error messages.
