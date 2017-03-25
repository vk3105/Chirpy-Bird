

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SetSession
 */
public class SetSession extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	
		String text = request.getParameter("text");
		String filterString = request.getParameter("filterString");
		if (text != null && text.length() > 0) {
			request.getSession().setAttribute("QueryString", text);
		}
		if (filterString != null && filterString.length() > 0) {
			request.getSession().setAttribute("FilterString", filterString);
		}
	}

}
