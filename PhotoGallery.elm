module PhotoGallery exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)

-- MODEL

type alias Model =
  { query : String
  , results : List SearchResult
  }

type alias SearchResult =
  { userName : String
  , likes : Int
  , photoUrl : String
  }

type Msg
  = SetQuery String

initialModel : Model
initialModel =
  { query = "blah"
  , results =
    [ { userName = "Lauren"
      , likes = 5
      , photoUrl = "blah"
      }
    ]
  }

 -- UPDATE
update : Msg -> Model -> Model
update msg model =
    model

-- VIEW
view : Model -> Html Msg
view model =
  div [ class "smallgrid even" ] (List.map viewSearchResult model.results)



viewSearchResult : SearchResult -> Html Msg
viewSearchResult result =
  div [ class "description" ]
    [ div [ class "text-holder" ]
        [ h3 []
            [ text "Photographer:" ]
        , h2 []
            [ text result.userName ]
        , p []
            [ text ("[Likes: " ++ (toString result.likes) ++ "]") ]
        ]
        ,
      div [ class "photo" ]
        [ img [ src result.photoUrl ] []
        ]
    ]

main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
