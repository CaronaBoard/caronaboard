module Login.View.Login exposing (login)

import Testable.Html exposing (Html, div, h1, b, p, input, text, form)
import Testable.Html.Events exposing (onInput, onSubmit)
import Testable.Html.Attributes exposing (class)
import Login.Msg exposing (Msg(..))
import Login.Model exposing (Model, Step(..), step)
import Login.View.EmailStep exposing (emailStep)
import Login.View.PasswordStep exposing (passwordStep)
import Common.Icon exposing (icon)


login : Model -> Html Msg
login model =
    case step model of
        EmailStep ->
            formStep (emailStep model)

        PasswordStep ->
            formStep (passwordStep model)

        NotRegisteredStep ->
            div []
                [ text "O CaronaBoard está em fase de testes, seja o primeiro a saber quando for lançado" ]


formStep : Html Msg -> Html Msg
formStep step =
    div [ class "login-background" ]
        [ div
            [ class "login-container" ]
            [ div [ class "login-item login-item-title" ]
                [ h1 []
                    [ b [] [ text "Carona" ]
                    , text "Board"
                    ]
                , p []
                    [ text "O CaronaBoard é um aplicativo de grupos de caronas, descubra quem está indo para o mesmo lugar que você e dê ou peça uma carona"
                    ]
                ]
            , div [ class "login-item login-item-form" ]
                [ div [ class "login-icon" ]
                    [ div [] [ icon "lock_outline" ]
                    , text "Entre com sua conta"
                    ]
                , form [ onSubmit Submit ] [ step ]
                , div [] [ text "Ainda estamos em fase beta, novos cadastros serão aceitos em breve" ]
                ]
            ]
        ]
