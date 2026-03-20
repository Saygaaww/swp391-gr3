package util;

import jakarta.servlet.ServletContext;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Centralized OAuth configuration resolver.
 * Priority: JVM system properties > OS environment variables > WEB-INF/oauth.properties.
 */
public final class OAuthConfig {

    private static final Logger LOGGER = Logger.getLogger(OAuthConfig.class.getName());
    private static final Properties FILE_PROPS = new Properties();

    private OAuthConfig() {
    }

    public static synchronized void load(ServletContext context) {
        FILE_PROPS.clear();

        // 1) Load from WEB-INF/oauth.properties if present.
        try (InputStream in = context.getResourceAsStream("/WEB-INF/oauth.properties")) {
            if (in != null) {
                FILE_PROPS.load(in);
                LOGGER.info("Loaded OAuth config from /WEB-INF/oauth.properties");
            } else {
                LOGGER.info("OAuth config file not found at /WEB-INF/oauth.properties; using env/JVM fallback");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Could not load /WEB-INF/oauth.properties", e);
        }

        // 2) Overlay known context-params for convenience.
        List<String> keys = Arrays.asList(
                "oauth.google.client.id",
                "oauth.google.client.secret",
                "oauth.facebook.client.id",
                "oauth.facebook.client.secret");

        for (String key : keys) {
            String value = context.getInitParameter(key);
            if (isNonBlank(value)) {
                FILE_PROPS.setProperty(key, value.trim());
            }
        }
    }

    public static String get(String propKey, String systemPropertyKey, String envKey) {
        String fromSystem = trimToNull(System.getProperty(systemPropertyKey));
        if (fromSystem != null) {
            return fromSystem;
        }

        String fromEnv = trimToNull(System.getenv(envKey));
        if (fromEnv != null) {
            return fromEnv;
        }

        synchronized (OAuthConfig.class) {
            return trimToNull(FILE_PROPS.getProperty(propKey));
        }
    }

    private static boolean isNonBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
