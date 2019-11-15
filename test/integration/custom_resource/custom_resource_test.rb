describe file('/opt/perlbrew/perls/5.30.1') do
  it { should exist }
  its('type') { should eq :directory }
end

describe command('/opt/perlbrew/perls/5.30.1/bin/perl -v') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /v5.30.1/ }
end
