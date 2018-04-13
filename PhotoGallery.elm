module PhotoGallery exposing (..)
import Html exposing (..)
--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)

initialModel : { introText : String }
initialModel =
  {
  introText = "hello"
  }


view: a -> Html msg
view model =
  h1 [] [text initialModel.introText]


update msg model =
    model


main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
