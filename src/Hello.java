

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import first.PersonBean;

public class Hello extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public Hello() {}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		/*response.setContentType("text/html");
		PrintWriter out=response.getWriter();
		
		out.print("<html><body>");
		out.print("<h3>Hello Sir</h3>");
		out.print("</body></html>");*/
		
		PersonBean person = new PersonBean();
		person.setName(request.getParameter("name"));
		person.setMail(request.getParameter("mail"));
		person.doSomething();
		request.setAttribute("person", person);
		getServletContext().getRequestDispatcher("/Home.jsp").forward(request, response);
	}

}
