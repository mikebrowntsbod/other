class sys_users (
$pam = simplib::lookup('simp_options::pam', { 'default_value' => false }),
){

group { 'local_admin':
  gid => '454'
}

user { 'local_admin':
  ensure  => 'present',
  allowdupe => 'false,
  uid => '454',
  gid => '454',
  groups => 'wheel'
  home => '/home/local_admin'
  password => '1$$kBIbtOzW$u2CAbiacXbvIpGuJ68obS.'
  require => Group['local_admin'],
}

if $pam {
  include '::pam'
  
  pam::access::rule { 'allow_local_admin':
    users => ['local_admin'],
    origins => ['ALL'],
    comment => 'The local user, used to locally login to the system in the case of a lockout.'
    }
}

sudo::user_specification { 'default_local_admin':
  user_list => ['local_admin'],
  runas => 'root',
  cmnd => ['/bin/su root', '/bin/su - root', '/bin/sudosh'],
  passwd => false
}

}
