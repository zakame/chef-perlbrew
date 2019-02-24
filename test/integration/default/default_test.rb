describe command('/opt/perlbrew/bin/perlbrew version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /App::perlbrew/ }
end

describe file('/etc/profile.d/perlbrew.sh') do
  it { should exist }
end
