module PhotoGallery exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


initialModel =

view model =


-- viewSearchResult result =
--     li []
--         [ span [ class "star-count" ] [ text (toString result.stars) ]
--         , a [ href ("https://github.com/" ++ result.name), target "_blank" ]
--             [ text result.name ]
--         , button
--             [ class "hide-result" ]
--             [ text "X" ]
--         ]


update msg model =
    model


main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
