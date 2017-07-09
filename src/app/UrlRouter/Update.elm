module UrlRouter.Update exposing (changePageTo, init, update, urlRouterUpdate)

import Common.Response exposing (Response(..))
import GiveRide.Model exposing (Msg(..))
import Login.Model as Login exposing (Msg(..))
import Model as Root exposing (Msg(..))
import Navigation exposing (Location)
import Notifications.Model as Notifications exposing (isEnabled)
import Profile.Model as Profile exposing (Msg(..))
import Return exposing (Return, return)
import UrlRouter.Model exposing (Model, Msg(..))
import UrlRouter.Routes exposing (Page(..), pathParser, redirectTo, toPath)


init : Location -> Model
init location =
    case pathParser location of
        Nothing ->
            { page = SplashScreenPage
            }

        Just page ->
            { page = page }


update : Root.Msg -> Root.Model -> Return UrlRouter.Model.Msg Model
update msg { notifications, profile, login, urlRouter } =
    case msg of
        MsgForUrlRouter urlMsg ->
            urlRouterUpdate profile login urlMsg urlRouter

        MsgForLogin (SignInResponse (Success _)) ->
            urlRouterUpdate profile login (Go urlRouter.page) urlRouter

        MsgForLogin (SignOutResponse (Success _)) ->
            urlRouterUpdate profile login (Go LoginPage) urlRouter

        MsgForLogin (PasswordResetResponse (Success _)) ->
            urlRouterUpdate profile login (Go PasswordResetPage) urlRouter

        MsgForGiveRide (GiveRideResponse (Success _)) ->
            if isEnabled notifications then
                urlRouterUpdate profile login (Go GroupsPage) urlRouter
            else
                urlRouterUpdate profile login (Go EnableNotificationsPage) urlRouter

        MsgForProfile (ProfileResponse (Success _)) ->
            urlRouterUpdate profile login (Go GroupsPage) urlRouter

        _ ->
            return urlRouter Cmd.none


urlRouterUpdate : Profile.Model -> Login.Model -> UrlRouter.Model.Msg -> Model -> Return UrlRouter.Model.Msg Model
urlRouterUpdate profile login msg model =
    case msg of
        Go route ->
            ( model, Navigation.newUrl (toPath route) )

        UrlChange location ->
            changePageTo profile login model location

        Back ->
            return model (Navigation.back 1)


changePageTo : Profile.Model -> Login.Model -> Model -> Location -> Return UrlRouter.Model.Msg Model
changePageTo profile login model location =
    let
        requestedPage =
            Maybe.withDefault NotFoundPage (pathParser location)

        pageAfterRedirect =
            redirectTo profile login requestedPage

        shouldModifyUrl =
            requestedPage /= pageAfterRedirect

        navigationCmd =
            if shouldModifyUrl then
                Navigation.modifyUrl <| toPath pageAfterRedirect
            else
                Cmd.none
    in
    return { model | page = pageAfterRedirect } navigationCmd
