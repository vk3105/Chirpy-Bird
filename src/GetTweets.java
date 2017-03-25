

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.impl.XMLResponseParser;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;

import com.google.gson.Gson;

import first.Tweet;

/**
 * Servlet implementation class GetTweets
 */
public class GetTweets extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String urlString = "http://54.213.21.75:8983/solr/clirv2";
	private int rowCount = 25;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String query = request.getParameter("queryString");
		String langFilterStr = request.getParameter("langFilter");
		String regFilterStr = request.getParameter("regFilter");
		int[] langFilters = new int[5];
		int[] regFilters = new int[5];
		
		for(int i=0;i<5;i++){
			langFilters[i] = Integer.parseInt(String.valueOf(langFilterStr.charAt(i)));
			regFilters[i] = Integer.parseInt(String.valueOf(regFilterStr.charAt(i)));
		}
		
		List<Tweet> tweetList = getTweets(query,langFilters, regFilters);
	    String json = new Gson().toJson(tweetList);
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
	}
	
	public List<Tweet> getTweets(String queryText, int[] langFilters, int[] regFilters)
	{
		List<Tweet> tweetList = new ArrayList<Tweet>();
		try{
			
			if(langFilters[1] == 1){
				tweetList.addAll(fetchTweets(queryText,"en"));
			}
			if(langFilters[2] == 1){
				tweetList.addAll(fetchTweets(queryText,"es"));
			}
			if(langFilters[3] == 1){
				tweetList.addAll(fetchTweets(queryText,"de"));
			}
			if(langFilters[4] == 1){
				tweetList.addAll(fetchTweets(queryText,"fr"));
			}
			

			/*String regFilterQuery = "";
			if(regFilters[0] == 0){
				if(regFilters[1] == 1){
					regFilterQuery = regFilterQuery + "user.location: USA user.location: United States Mountain Time (US & Canada) user.location: Central Time (US & Canada) ";
				}
				if(regFilters[2] == 1){
					regFilterQuery = regFilterQuery + "user.location: Mexico user.location: Mexico user.location: México user.time_zone:Mexico City ";
				}
				if(regFilters[3] == 1){
					regFilterQuery = regFilterQuery + "user.location: Germany ";
				}
				if(regFilters[4] == 1){
					regFilterQuery = regFilterQuery + "user.location: France user.location: Paris user.location: Paris,France ";
				}
				regFilterQuery = regFilterQuery.substring(0,regFilterQuery.length() - 1);
			}*/
						
		}
		catch(Exception e)
		{
			
		}
		return filterRegion(MixTweets(tweetList),regFilters);
	}
	
	public List<Tweet> filterRegion(List<Tweet> origList, int[] regFilters)
	{
		List<Tweet> tweetList = new ArrayList<Tweet>();
		
		if(regFilters[0] == 1){
			return origList;
		}
		else{
			for(int i=0; i<origList.size(); i++){
				if(origList.get(i).getRegion() != null && origList.get(i).getRegion() != "")
				{
					if(regFilters[1] == 1){
						if(origList.get(i).getRegion().startsWith("Pacific Time") ||
								origList.get(i).getRegion().startsWith("Arizona") ||
								origList.get(i).getRegion().startsWith("Mexico City") ||
								origList.get(i).getRegion().startsWith("Eastern Time"))
						{
							tweetList.add(origList.get(i));
						}
					}
					if(regFilters[2] == 1){
						if(origList.get(i).getRegion().startsWith("Beijing") ||
								origList.get(i).getRegion().startsWith("Paris") ||
								origList.get(i).getRegion().startsWith("Brussels") ||
								origList.get(i).getRegion().startsWith("Casablanca") ||
								origList.get(i).getRegion().startsWith("Belgrade") ||
								origList.get(i).getRegion().startsWith("Ljubljana") ||
								origList.get(i).getRegion().startsWith("London") ||
								origList.get(i).getRegion().startsWith("Amsterdam") ||
								origList.get(i).getRegion().startsWith("Greenland") ||
								origList.get(i).getRegion().startsWith("Hawaii") ||
								origList.get(i).getRegion().startsWith("UTC") ||
								origList.get(i).getRegion().startsWith("Europe"))
						{
							tweetList.add(origList.get(i));
						}
					}
					if(regFilters[3] == 1){
						if(origList.get(i).getRegion().startsWith("Bern") ||
								origList.get(i).getRegion().startsWith("Athens") ||
								origList.get(i).getRegion().startsWith("Berlin") ||
								origList.get(i).getRegion().startsWith("Brussels") ||
								origList.get(i).getRegion().startsWith("Stockholm") ||
								origList.get(i).getRegion().startsWith("Copenhagen") ||
								origList.get(i).getRegion().startsWith("Vienna") ||
								origList.get(i).getRegion().startsWith("Tallinn") ||
								origList.get(i).getRegion().startsWith("Brasilia"))
						{
							tweetList.add(origList.get(i));
						}
					}
					if(regFilters[4] == 1){
						if(origList.get(i).getRegion().startsWith("Bogota") ||
								origList.get(i).getRegion().startsWith("Lima") ||
								origList.get(i).getRegion().startsWith("Madrid") ||
								origList.get(i).getRegion().startsWith("Moscow") ||
								origList.get(i).getRegion().startsWith("Quito") ||
								origList.get(i).getRegion().startsWith("Buenos") ||
								origList.get(i).getRegion().startsWith("Aires") ||
								origList.get(i).getRegion().startsWith("La Paz") ||
								origList.get(i).getRegion().startsWith("Georgetown") ||
								origList.get(i).getRegion().startsWith("Santiago") ||
								origList.get(i).getRegion().startsWith("Quito") ||
								origList.get(i).getRegion().startsWith("Jerusalem") ||
								origList.get(i).getRegion().startsWith("Moscow") ||
								origList.get(i).getRegion().startsWith("Lisbon"))
						{
							tweetList.add(origList.get(i));
						}
					}
				}
			}
		
			return tweetList;
		}
	}
	
	public List<Tweet> fetchTweets(String queryText, String lang)
	{
		
		List<Tweet> tweetList = new ArrayList<Tweet>();
		try{
		Tweet tweety;
		SolrClient solr = new HttpSolrClient.Builder(urlString).build();
        ((HttpSolrClient) solr).setParser(new XMLResponseParser());

	    SolrQuery query = new SolrQuery();
	    query.setQuery("{!ModifiedQueryParserGoogleApi2}"+queryText);
	    query.setRows(rowCount);
	    query.setSort("score",ORDER.desc);
	   
	    query.setFilterQueries("lang:"+lang);
	    
	    //query.addFilterQuery("cat:electronics","store:amazon.com");
	    //query.setFields("id","price","merchant","cat","store");
	    //query.setStart(0);    
	    //query.set("defType", "edismax");

	    QueryResponse response = solr.query(query);
	    SolrDocumentList results = response.getResults();
	    String id = "";
	    String text = "";
	    String userName = "";
	    String userHandle = "";
	    String tweetLang = "";
	    String tweetRegion = "";
	    String tweetDate = "";
	    
	    for (int i = 0; i < results.size(); ++i) {
	      SolrDocument solrDoc= results.get(i);
	      id = (String) solrDoc.getFieldValue("id");
	      text = (String) solrDoc.getFieldValue("text");
	      userName = (String) solrDoc.getFieldValue("user.name");
	      userHandle = (String) solrDoc.getFieldValue("user.screen_name");
	      tweetLang = (String) solrDoc.getFieldValue("lang");
	      tweetRegion = (String) solrDoc.getFieldValue("user.time_zone");
	      tweetDate = (String) solrDoc.getFieldValue("created_at");
	      //System.out.println(text + " " + userName + " " + userHandle + " "+ tweetLang + " " + tweetRegion+" "+tweetDate);
	      tweety = new Tweet(id,text,userName,"@"+userHandle,tweetLang,tweetRegion,tweetDate,"", "", "", "");
	      tweetList.add(tweety);	
	    }
		}
		catch(Exception e)
		{
			
		}
	    return tweetList;

	}
	
	public List<Tweet> MixTweets(List<Tweet> tweetList)
	{
		List<Tweet> mixtweetList = new ArrayList<Tweet>();
		
		int a=0;
		int b=25;
		int c=50;
		int d=75;
		
		while(a<25){
			if(a < tweetList.size())
				mixtweetList.add(tweetList.get(a));
			if(b < tweetList.size())
				mixtweetList.add(tweetList.get(b));
			if(c < tweetList.size())
				mixtweetList.add(tweetList.get(c));
			if(d < tweetList.size())
				mixtweetList.add(tweetList.get(d));
			a++;
			b++;
			c++;
			d++;
		}
		
		return mixtweetList;
	}

}
