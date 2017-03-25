package first;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;

public class Translate {

	public static String translateText(String queryText,String fromLang, String toLang) {
        //String queryText = "Refugee from India";
        //String fromLang = "en";
        //String toLang = "de";

        String output = callTranslate(queryText, fromLang, toLang);
        return output;
	}
	
	public static String cleanText(String text){
		text = text.replace("\n", "\\n");
		text = text.replaceAll("\t", "\\t");
		text = text.replace("\\", "");
		return text;
	}
	
	public static String callTranslate(String queryText, String fromLang, String toLang) {
		queryText = URLEncodedString(queryText);
        String queryUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20161204T043542Z.45074501e4344842.bb1fa18b643317955619ff21ce7e4ef1b06e91fc";
        
        String newUrl = queryUrl + "&text=" + queryText + "&lang=" + fromLang + "-" + toLang;

        StringBuilder sb = new StringBuilder();
        HttpURLConnection urlConn = null;
        InputStreamReader in = null;
        try {
            URL url = new URL(newUrl);
            urlConn = (HttpURLConnection) url.openConnection();
            if (urlConn != null)
                urlConn.setReadTimeout(60 * 1000);
            if (urlConn != null && urlConn.getInputStream() != null) {
                in = new InputStreamReader(urlConn.getInputStream(), Charset.defaultCharset());
                BufferedReader bufferedReader = new BufferedReader(in);
                if (bufferedReader != null) {
                    int cp;
                    while ((cp = bufferedReader.read()) != -1) {
                        sb.append((char) cp);
                    }
                    bufferedReader.close();
                }
            }
            in.close();
        } catch (Exception e) {
            throw new RuntimeException("Exception while calling URL:" + newUrl, e);
        }

        String output = sb.toString();
        output = output.substring(output.indexOf("[")+2, output.indexOf("]")-1);
        output = cleanText(output);
        return output;
    }
	
	public static String URLEncodedString(String str) {
		try {
			return URLEncoder.encode(str, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return str;
		}
	}
	
}
