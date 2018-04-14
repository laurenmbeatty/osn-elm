module PhotoGallery exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

-- MODEL

type alias Model =
  { query : String
  , results : List SearchResult
  }

type alias SearchResult =
  { userName : String
  , likes : Int
  , photoUrl : String
  , styleClass: String
  }

type Msg
  = GetPhotos
  | PhotosResult (Result Http.Error (List SearchResult))

init : (Model, Cmd Msg)
init =
  ({ query = "json server", results = [] }, Cmd.none)

initialModel : Model
initialModel =
  { query = "blah"
  , results =
    [ { userName = "Lauren"
      , likes = 5
      , photoUrl = "https://andybarefoot.com/codepen/images/albums/02.jpg"
      , styleClass = "smallgrid odd"
      }
      ,
      { userName = "Joe"
      , likes = 10
      , photoUrl = "https://andybarefoot.com/codepen/images/albums/02.jpg"
      , styleClass = "smallgrid even"
      }
    ]
  }

 -- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    --model
    case msg of
      GetPhotos ->
        let
          cmd =
            Http.send PhotosResult <|
              Http.get "https://api.unsplash.com/photos/?page=2&per_page=24&client_id=TODOputclientidhere" decodePhotos
        in
          ( model, cmd )

      PhotosResult (Ok results) ->
        ({ model | results = results, query = ""}, Cmd.none)
      PhotosResult (Err err) ->
        ({model | results = [], query = (toString err) }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div [ class "image-container"] (List.map viewSearchResult model.results)

viewSearchResult : SearchResult -> Html Msg
viewSearchResult result =
  div [ class result.styleClass ]
  [
    div [ class "description" ]
      [ div [ class "text-holder" ]
          [ h3 []
              [ text "Photographer:" ]
          , h2 []
              [ text result.userName ]
          , p []
              [ text ("[Likes: " ++ (toString result.likes) ++ "]") ]
          ]
      ]
      ,
      div [ class "photo" ]
        [ img [ src result.photoUrl ] []
        ]
  ]

 -- HTTP
-- getPhotos : Http.Request SearchResult
-- getPhotos =
--   Http.get "https://api.unsplash.com/photos/?page=2&per_page=24&client_id=Td1e55bf6704f4b99e93ae57786f434b354a42e5394d5aa34705720922c6cd652"

photoResultDecoder : Json.Decode.Decoder SearchResult
photoResultDecoder =
  Json.Decode.Pipeline.decode SearchResult
    |> Json.Decode.Pipeline.required "userName" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "likes" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "photoUrl" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "styleClass" (Json.Decode.string)

decodePhotos : Json.Decode.Decoder (List SearchResult)
decodePhotos =
  Json.Decode.list photoResultDecoder

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
