require 'spec_helper'

describe 'MySQL Service' do
  describe service('mysql') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening }
  end

  %w( /var/optoro/backup/backup2.sh /etc/logrotate.d/mysql-slow ).each do |files|
    describe file(files) do
      it { should be_file }
    end
  end

  describe 'backup cron job' do
    describe cron do
      cron_entry = '0 5 * * * /var/optoro/backup/backup2.sh'
      it { should have_entry(cron_entry).with_user('deploy')  }
    end
  end

  describe file('/etc/mysql/my.cnf') do
    it { should contain('skip-innodb_doublewrite = 1') }
    it { should contain('innodb_use_native_aio = 1') }
  end
end