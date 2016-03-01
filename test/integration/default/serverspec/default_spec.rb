require 'spec_helper'

packages = %w(unzip )

ports = %w(80 3306)
ports.each do |port|
  describe port (port) do
    it { should be_listening }  end
  end
end
