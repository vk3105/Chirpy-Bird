package first;

public class PersonBean {
	private String name = "DefaultName";
	private String mail = "fu@fu.com";
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public void doSomething()
	{
		setName("["+ getName() +"]");
		setMail("["+ getMail() +"]");
	}
}

