require 'net/ldap' 

def name_for_login( email, password )
    email = email[/\A\w+/].downcase  # Throw out the domain, if it was there
    email << "@unal.edu.co"        # I only check people in my company
    ldap = Net::LDAP.new(
      host: 'sia.unal.edu.co',    # Thankfully this is a standard name
      auth: { method: :simple, email: email, password:password }
    )
    if ldap.bind
      puts "find!!!"
    end
end