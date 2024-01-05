###Our script enumerates more groups than net.exe including Print Operators, IIS_IUSRS, and others. This is because it enumerates all AD objects including Domain Local groups (not just global groups).
### Import-Module .\function.ps1
### LDAPSearch -LDAPQuery "(samAccountType=805306368)"
### LDAPSearch -LDAPQuery "(objectclass=group)"
### $sales = LDAPSearch -LDAPQuery "(&(objectCategory=group)(cn=Sales Department))"
### $group = LDAPSearch -LDAPQuery "(&(objectCategory=group)(cn=Development Department*))"
### $group = LDAPSearch -LDAPQuery "(&(objectCategory=group)(cn=Management Department*))"
### $group.properties.member 
### An additional thing to note here is that while it appears that jen is only a part of the Management Department group, she is also an indirect member of the Sales Department and Development Department groups, since groups typically inherit each other. This is normal behavior in AD; however, if misconfigured, users may end up with more privileges than they were intended to have. This might allow attackers to take advantage of the misconfiguration to further expand their reach inside the compromised domain.


function LDAPSearch {
    param (
        [string]$LDAPQuery
    )

    $PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
    $DistinguishedName = ([adsi]'').distinguishedName

    $DirectoryEntry = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$PDC/$DistinguishedName")

    $DirectorySearcher = New-Object System.DirectoryServices.DirectorySearcher($DirectoryEntry, $LDAPQuery)

    return $DirectorySearcher.FindAll()

}



