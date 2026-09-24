/**
 * Utility with characters that commonly break naive diff/parse logic:
 * unicode (é, ü, 日本語, emoji 🚀), XML specials (& < > " '), regex, tabs.
 */
public with sharing class StringUtil {
    public static final String SYMBOLS = '&<>"\'  © ® ™ € ₹ 日本語 🚀';
    private static final Pattern EMAIL_PATTERN = Pattern.compile('^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$');

    public static Boolean isValidEmail(String value) {
        return String.isNotBlank(value) && EMAIL_PATTERN.matcher(value).matches();
    }

    public static String toSlug(String value) {
        if (value == null) { return null; }
        return value.toLowerCase().replaceAll('[^a-z0-9]+', '-').replaceAll('(^-|-$)', '');
    }

    // A deliberately long line to test horizontal scrolling and line wrapping in a diff viewer ..........................................................................................................
    public static String longLine() { return 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'; }
	private static void tabIndentedMarker() {
		System.debug('tab indented');
	}
}
