package first;

public class Tweet {
	private String rank;
	private String text;
	private String userName;
	private String userHandle;
	private String language;
	private String region;
	private String date;
	private String englishText;
	private String spanishText;
	private String germanText;
	private String frenchText;
	
	public Tweet(String rank, String text, String userName, String userHandle, String language, String region, String date,
			String englishText, String spanishText, String germanText, String frenchText) {
		super();
		this.rank = rank;
		this.text = text;
		this.userName = userName;
		this.userHandle = userHandle;
		this.language = language;
		this.region = region;
		this.date = date;
		this.englishText = englishText;
		this.spanishText = spanishText;
		this.germanText = germanText;
		this.frenchText = frenchText;
	}
	
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserHandle() {
		return userHandle;
	}
	public void setUserHandle(String userHandle) {
		this.userHandle = userHandle;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getEnglishText() {
		return englishText;
	}
	public void setEnglishText(String englishText) {
		this.englishText = englishText;
	}
	public String getSpanishText() {
		return spanishText;
	}
	public void setSpanishText(String spanishText) {
		this.spanishText = spanishText;
	}
	public String getGermanText() {
		return germanText;
	}
	public void setGermanText(String germanText) {
		this.germanText = germanText;
	}
	public String getFrenchText() {
		return frenchText;
	}
	public void setFrenchText(String frenchText) {
		this.frenchText = frenchText;
	}
	
}
