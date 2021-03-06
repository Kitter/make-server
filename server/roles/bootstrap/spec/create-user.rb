#  _                 _       _                     __                   
# | |__   ___   ___ | |_ ___| |_ _ __ __ _ _ __   / /__ _ __   ___  ___ 
# | '_ \ / _ \ / _ \| __/ __| __| '__/ _` | '_ \ / / __| '_ \ / _ \/ __|
# | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) / /\__ \ |_) |  __/ (__ 
# |_.__/ \___/ \___/ \__|___/\__|_|  \__,_| .__/_/ |___/ .__/ \___|\___|
#                                         |_|          |_|              
describe 'bootstrap/create-user' do
  ansiblevars = MakeServer::Ansible.load_variables
  accountdata = MakeServer::Ansible.load_variables('login-users.yml')

  if ansiblevars['role']['config']['adduser'] then
    accountdata['role']['unixusers'].each do |e|
      # Test each user
      describe user(e['username']) do
        it { should exist }
        it { should belong_to_group e['group'] }
        it { should have_uid e['uid'] }
        it { should have_home_directory e['home'] }
        it { should have_login_shell e['shell'] }
      end
    end

    accountdata['role']['belongsto'].each do |e|
      # Belongs to other group
      describe group(e['group']) do
        it { should exist }
      end

      e['users'].each do |u|
        describe user(u) do
          it { should exist }
          it { should belong_to_group e['group'] }
        end
      end
    end
  end
end
