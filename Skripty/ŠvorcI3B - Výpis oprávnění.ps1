# Zobrazení všech možných oprávnění (FullControl, Modify, ReadAndExecute, ...)
[enum]::GetValues('System.Security.AccessControl.FileSystemRights')

# Zobrazení typů dědičnosti (None, ContainerInherit, ObjectInherit)
[enum]::GetValues('System.Security.AccessControl.InheritanceFlags')

# Zobrazení všech flagů (None, NoPropagateInherit, InheritOnly, ...)
[enum]::GetValues('System.Security.AccessControl.PropagationFlags')

# Zobrazení typu oprávnění ACE (Allow, Deny)
[enum]::GetValues('System.Security.AccessControl.AccessControlType')