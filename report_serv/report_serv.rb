# frozen_string_literal: true

require 'socket'
require 'csv'
require 'json'

prices_csv = CSV.read('./02_ruby_prices.csv', converters: :numeric).to_h
server = TCPServer.new 5679

while session = server.accept
  request = JSON.parse(session.gets.split[1].split('?')[1])
  #puts request

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: text/html\r\n"
  session.print "\r\n"

  vms_csv = request['data']
  #puts "vms_csv: #{vms_csv}"
  class VirtualMachine
    attr_accessor :id, :cpu, :ram, :hdd_type, :hdd_capacity
    def initialize(vms)
      @id = vms['id']
      @cpu = vms['cpu']
      @ram = vms['ram']
      @hdd_type = vms['hdd_type']
      @hdd_capacity = vms['hdd_capacity']
    end
  end

  class CreateData
    class << self
      attr_reader :vms, :prices

      def create_data(vms, prices)
        @vms = vms
        @prices = prices
        create_vm
      end

      def create_vm
      	  #puts "@vms: #{@vms}"
        @vms.map! do |vm|
          new_vm = VirtualMachine.new(vm)
        end
      end
    end
  end

  class Report
    attr_accessor :costs

    def initialize(vms, prices)
      @vms = vms
      @prices = prices
      calc_the_costs_of_vms
    end

    def calc_the_costs_of_vms
      costs = []
      @vms.each do |vm|
        cost = (vm.cpu * @prices['cpu'] + vm.ram * @prices['ram'] + vm.hdd_capacity * @prices[vm.hdd_type.to_s]) / 100
        costs << [vm.id, cost]
      end
      costs = costs.sort_by! { |x| x[1] }
    end

    def most_expencive(n)
      calc_the_costs_of_vms.last(n)
    end

    def less_expencive(n)
      calc_the_costs_of_vms.reverse.last(n)
    end

    def largest_vm_by_capacity(n, hdd_type)
      all_capacities = []
      @vms.each do |vm|
        capacity = 0
        capacity += vm.hdd_capacity if vm.hdd_type == hdd_type
        all_capacities << [vm.id, capacity]
        all_capacities = all_capacities.sort_by! { |x| x[1] }
      end
      all_capacities.last(n)
    end
  end



  CreateData.create_data(vms_csv, prices_csv)
  report = Report.new(CreateData.vms, CreateData.prices)

  report1 = report.most_expencive(2)
  report2 = report.less_expencive(2)
  report3 = report.largest_vm_by_capacity(2, 'sata')

  #main_report = [report1, report2, report3].to_s
  main_report = "Наиболее дорогие ВМ: #{report1}; Наиболее дешёвые ВМ: #{report2}; Наиболее объёмные ВМ, типа sata: #{report3};".to_json

  session.print "#{main_report}"

  session.close
end
