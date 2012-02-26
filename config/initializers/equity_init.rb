#custom config and resources for equity component

#print global vars
puts "Rails.env: #{Rails.env}"
puts "Rails.root: #{Rails.root}"

#load additional custom config
#APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

####equity conditions###########

#condition name and cocde
C_HBV_CODE = "hbv"
C_HBV_NAME = "HBV Infection"
C_HCV_CODE = "hcv"
C_HCV_NAME = "HCV Infection"
C_HPV_CODE = "hpv"
C_HPV_NAME = "HPV Infection"
C_HIV_CODE = "hiv"
C_HIV_NAME = "HIV Infection"
C_DIABETES_CODE = "diabetes"
C_DIABETES_NAME = "Diabetes"
C_OBESITY_CODE = "obesity"
C_OBESITY_NAME = "Obesity"

#map from name to code (implemented))
CONDITION_OPTIONS = {
  C_HBV_NAME => C_HBV_CODE,
  C_HCV_NAME => C_HCV_CODE
}

#map from code to name
CONDITION_NAMES = {
  C_HBV_CODE => C_HBV_NAME,
  C_HCV_CODE => C_HCV_NAME,
  C_HPV_CODE => C_HPV_NAME,
  C_HIV_CODE => C_HIV_NAME,
  C_DIABETES_CODE => C_DIABETES_NAME,
  C_OBESITY_CODE => C_OBESITY_NAME,
}
#map from code to description
CONDITION_DESCS = {
  C_HBV_CODE => "Check for HBV infection risk, get personalized CDC guideline for screening, vaccination, monitoring or early treatment. ",
  C_HCV_CODE => "Check for HCV infection risk, get personalized CDC guideline for screening, monitoring or early treatment.",
  C_HPV_CODE => "Check for HPV infection risk, get personalized CDC guideline. ",
  C_HIV_CODE => "Check for HIV infection risk, get personalized CDC guideline. ",
  C_DIABETES_CODE => "Check for risk of diabetes, get personalized CDC guideline. ",
  C_OBESITY_CODE => "Check for risk of obesity, get personalized CDC guideline. ",
}

#test status
TEST_STATUS_UNTESTED = "Untested"
TEST_STATUS_TESTED = "Tested"
TEST_STATUS_TESTED_INCOMPLETE = "Incomplete test"
TETS_STATUS_SUSCEPTIBLE = "Susceptable"
TEST_STATUS_IMMUNE_NATURAL = "Immune due to natural infection"
TEST_STATUS_IMMUNE_VACCINE = "Immune due to hepatitis B vaccination"
TEST_STATUS_INFECTED_ACUTE = "Acutely infected"
TEST_STATUS_INFECTED_CHRONIC = "Chronically infected"
TEST_STATUS_INFECTED = "Infected"
TEST_STATUS_NOT_INFECTED = "Not infected"
TEST_STATUS_RESULT_UNCLEAR = "Result interpretation unclear"

#load countries with HBV prevalence >2% or 8%
#format: region \t country name [\t code \t 2 \t 8]
begin
  HBV_PREVALENCE2 = {}  #country code=>2
  HBV_PREVALENCE8 = {}  #country code=>2
  @rfile = File.open(File.join(Rails.root, "/resources/world-regions-hbv.txt"), "r")
  @rfile.each_line() do |line|
    #print line
    region, name, code, p2, p8 = line.split(/\t/)
    if(code)
      if(p2.strip == '2')
        HBV_PREVALENCE2.store(code, '2')
      end
      if(p8.strip == '8')
        HBV_PREVALENCE8.store(code, '8')
      end
    end
  end
  @rfile.close
  puts "loaded #{@rfile.path} 2%: #{HBV_PREVALENCE2.size}, 8%: #{HBV_PREVALENCE8.size}"
rescue SystemCallError
  $stderr.print "failed to load file: /resources/world-regions-hbv.txt\n" + $!
  #raise
end

#load country code and names
#format: code | name
begin
  COUNTRY_OPTIONS = {"UNITED STATES OF AMERICA" => "US"}  #name=>code
  @cfile = File.open(File.join(Rails.root, "/resources/country-codes.txt"), "r")
  @cfile.each_line() do |line|
    code, name = line.split(/\t/)
    COUNTRY_OPTIONS.store(name, code)
  end
  @cfile.close
  puts "loaded #{@cfile.path} #{COUNTRY_OPTIONS.size}"
rescue
  $stderr.print "failed to load file: /resources/country-codes.txt\n"
  #raise
end

#options of races: name=>code
RACE_OPTIONS = {
    'White' => '1',
    'Black or African American' => '2',
    'American Indian and Alaska Native' => '3',
    'Native Hawaiian and Pacific Islander' => '4',
    'Asian' => '5',
    'Hispanic and Latino' => '6',
    'Other Race' => '7',
    'Mixed Race' => '8'
}

begin
  HELP_LINES = []
  @hfile = File.open(File.join(Rails.root, "/resources/faq.txt"), "r")
  @hfile.each_line() do |line|
    HELP_LINES.push(line)
  end
  @hfile.close
  puts "loaded #{@hfile.path} #{HELP_LINES.size}"
rescue
  $stderr.print "failed to load file: /resources/faq.txt\n"
end

