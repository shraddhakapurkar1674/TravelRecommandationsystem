/* =========================================================
   TRIP NETRA - API CONFIGURATION

   Local frontend  : http://localhost:8088
   Local backend   : http://localhost:8091

   Deployed frontend: http://localhost:8080
   Deployed backend : http://localhost:8080/api
   ========================================================= */

(function () {
    "use strict";

    /*
     * ONE SWITCH - choose how the backend is run:
     *
     *  "JAR"    -> backend started with:  java -jar Travel_Recommendation_System-0.0.1-SNAPSHOT.war
     *              (no STS, no Eclipse, no Tomcat for the backend)  -> http://localhost:8091
     *  "TOMCAT" -> backend deployed as api.war in the SAME Tomcat as the frontend
     *              -> http://localhost:8080/api   (controllers add /api again => /api/api/...)
     */
    const BACKEND_MODE = "TOMCAT";

    const IS_LOCAL =
        window.location.hostname === "localhost" ||
        window.location.hostname === "127.0.0.1";

    const FRONTEND_CONTEXT_PATH =
        typeof window.APP_CONTEXT_PATH === "string"
            ? window.APP_CONTEXT_PATH
            : "";

    // Use the SAME host the browser used (localhost vs 127.0.0.1) so CORS matches
    const HOST = window.location.hostname || "localhost";

    const LOCAL_BACKEND_URL = "http://" + HOST + ":8091";
    const TOMCAT_BACKEND_URL = "http://" + HOST + ":8080/api";

    // Live server: backend behind the same domain (change if yours differs)
    const LIVE_BACKEND_URL = "";
    console.log("API CONFIG VERSION: TOMCAT-MODE-v2");

    const BASE_URL = IS_LOCAL
        ? (BACKEND_MODE === "JAR" ? LOCAL_BACKEND_URL : TOMCAT_BACKEND_URL)
        : LIVE_BACKEND_URL;

    const FRONTEND_BASE_URL = FRONTEND_CONTEXT_PATH;

    function isAbsoluteUrl(value) {
        return (
            value.startsWith("http://") ||
            value.startsWith("https://") ||
            value.startsWith("data:") ||
            value.startsWith("blob:")
        );
    }

    function cleanPath(path) {
        path = String(path || "").trim();

        if (!path) {
            return "";
        }

        if (isAbsoluteUrl(path)) {
            return path;
        }

        if (!path.startsWith("/")) {
            path = "/" + path;
        }

        return path;
    }

    window.API_CONFIG = {

        BASE_URL: BASE_URL,

        FRONTEND_BASE_URL: FRONTEND_BASE_URL,

        api: function (path) {
            if (!path) {
                return BASE_URL;
            }

            path = cleanPath(path);

            if (isAbsoluteUrl(path)) {
                return path;
            }

            return BASE_URL + path;
        },

        upload: function (path) {
            if (!path) {
                return "";
            }

            path = cleanPath(path);

            if (isAbsoluteUrl(path)) {
                return path;
            }

            return BASE_URL + path;
        },

        /*
         * Generic image resolver.
         */
        image: function (path) {

            if (!path) {
                return "";
            }

            path = String(path).trim();

            if (isAbsoluteUrl(path)) {
                return path;
            }

            if (
                path.startsWith("/api/") ||
                path.startsWith("api/")
            ) {
                if (!path.startsWith("/")) {
                    path = "/" + path;
                }

                return BASE_URL + path;
            }

            if (
                path.startsWith("/uploads/") ||
                path.startsWith("uploads/")
            ) {
                if (!path.startsWith("/")) {
                    path = "/" + path;
                }

                return BASE_URL + path;
            }

            if (
                path.startsWith("/images/") ||
                path.startsWith("images/")
            ) {
                if (!path.startsWith("/")) {
                    path = "/" + path;
                }

                return FRONTEND_BASE_URL + path;
            }

            /*
             * Database destination image values normally contain
             * only the filename.
             */
            return this.destinationImage(path);
        },

        /*
         * DestinationController:
         * GET /api/destinations/images/{fileName}
         */
        destinationImage: function (fileName) {

            if (!fileName) {
                return "";
            }

            fileName = String(fileName).trim();

            if (isAbsoluteUrl(fileName)) {
                return fileName;
            }

            /*
             * If DB already contains a complete path, preserve it.
             */
            if (
                fileName.startsWith("/api/destinations/images/") ||
                fileName.startsWith("api/destinations/images/")
            ) {
                if (!fileName.startsWith("/")) {
                    fileName = "/" + fileName;
                }

                return BASE_URL + fileName;
            }

            /*
             * Remove only path prefixes that may have been stored
             * accidentally with the filename.
             */
            fileName = fileName
                .replace(/^\/+/, "")
                .replace(/^uploads\/+/i, "")
                .replace(/^images\/+/i, "");

            return BASE_URL +
                "/api/destinations/images/" +
                encodeURIComponent(fileName);
        },

        /*
         * HotelController image endpoint.
         */
        hotelImage: function (fileName) {

            if (!fileName) {
                return "";
            }

            fileName = String(fileName).trim();

            if (isAbsoluteUrl(fileName)) {
                return fileName;
            }

            fileName = fileName
                .replace(/^\/+/, "")
                .replace(/^uploads\/+/i, "")
                .replace(/^images\/+/i, "");

            return BASE_URL +
                "/api/hotels/images/" +
                encodeURIComponent(fileName);
        },

        /*
         * TransportController image endpoint.
         */
        transportImage: function (fileName) {

            if (!fileName) {
                return "";
            }

            fileName = String(fileName).trim();

            if (isAbsoluteUrl(fileName)) {
                return fileName;
            }

            fileName = fileName
                .replace(/^\/+/, "")
                .replace(/^uploads\/+/i, "")
                .replace(/^images\/+/i, "");

            return BASE_URL +
                "/api/transports/images/" +
                encodeURIComponent(fileName);
        }
    };

    const API_CONFIG = window.API_CONFIG;

    console.log("======================================");
    console.log("TRIP NETRA API CONFIGURATION");
    console.log("======================================");
    console.log("Host:", window.location.hostname);
    console.log("Port:", window.location.port);
    console.log("Path:", window.location.pathname);
    console.log("Local:", IS_LOCAL);
    console.log("Backend:", BASE_URL);
    console.log("Frontend context:", FRONTEND_CONTEXT_PATH);
    console.log(
        "Login:",
        FRONTEND_BASE_URL + "/login.jsp"
    );
    console.log("======================================");

})();