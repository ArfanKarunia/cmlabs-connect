// enum StatusLead { newLead, followedUp, accepted, rejected, onHold}

import '../models/inbox/property/status_lead_model.dart';
import '../utils/color.dart';

final List<StatusLead> statusLead = [
  StatusLead(
    title: 'New',
    query: 'new',
    isEnabled: true,
    bgColor: AppColors.bgPrimary,
    color: AppColors.primary,
  ),
  StatusLead(
    title: 'Followed Up',
    query: 'followed-up',
    isEnabled: true,
    bgColor: AppColors.bgInfo,
    color: AppColors.info,
  ),
  StatusLead(
    title: 'Accepted',
    query: 'accepted',
    isEnabled: true,
    bgColor: AppColors.bgSuccess,
    color: AppColors.success,
  ),
  StatusLead(
    title: 'Rejected',
    query: 'rejected',
    isEnabled: true,
    bgColor: AppColors.bgDanger,
    color: AppColors.danger,
  ),
  StatusLead(
    title: 'On Hold',
    query: 'on-hold',
    isEnabled: true,
    bgColor: AppColors.scaffoldBgColor,
    color: AppColors.textLight,
  ),
];

final List<Map<String, String>> internationalPhoneCodes = [
  {'label': 'AFG (+93)', 'value': '+93'}, // Afghanistan
  {'label': 'ALB (+355)', 'value': '+355'}, // Albania
  {'label': 'DZA (+213)', 'value': '+213'}, // Algeria
  {'label': 'ASM (+1684)', 'value': '+1684'}, // American Samoa
  {'label': 'AND (+376)', 'value': '+376'}, // Andorra
  {'label': 'AGO (+244)', 'value': '+244'}, // Angola
  {'label': 'AIA (+1264)', 'value': '+1264'}, // Anguilla
  {'label': 'ATA (+672)', 'value': '+672'}, // Antarctica
  {'label': 'ATG (+1268)', 'value': '+1268'}, // Antigua and Barbuda
  {'label': 'ARG (+54)', 'value': '+54'}, // Argentina
  {'label': 'ARM (+374)', 'value': '+374'}, // Armenia
  {'label': 'ABW (+297)', 'value': '+297'}, // Aruba
  {'label': 'AUS (+61)', 'value': '+61'}, // Australia
  {'label': 'AUT (+43)', 'value': '+43'}, // Austria
  {'label': 'AZE (+994)', 'value': '+994'}, // Azerbaijan
  {'label': 'BHS (+1242)', 'value': '+1242'}, // Bahamas
  {'label': 'BHR (+973)', 'value': '+973'}, // Bahrain
  {'label': 'BGD (+880)', 'value': '+880'}, // Bangladesh
  {'label': 'BRB (+1246)', 'value': '+1246'}, // Barbados
  {'label': 'BLR (+375)', 'value': '+375'}, // Belarus
  {'label': 'BEL (+32)', 'value': '+32'}, // Belgium
  {'label': 'BLZ (+501)', 'value': '+501'}, // Belize
  {'label': 'BEN (+229)', 'value': '+229'}, // Benin
  {'label': 'BMU (+1441)', 'value': '+1441'}, // Bermuda
  {'label': 'BTN (+975)', 'value': '+975'}, // Bhutan
  {'label': 'BOL (+591)', 'value': '+591'}, // Bolivia
  {'label': 'BIH (+387)', 'value': '+387'}, // Bosnia and Herzegovina
  {'label': 'BWA (+267)', 'value': '+267'}, // Botswana
  {'label': 'BRA (+55)', 'value': '+55'}, // Brazil
  {'label': 'IOT (+246)', 'value': '+246'}, // British Indian Ocean Territory
  {'label': 'VGB (+1284)', 'value': '+1284'}, // British Virgin Islands
  {'label': 'BRN (+673)', 'value': '+673'}, // Brunei
  {'label': 'BGR (+359)', 'value': '+359'}, // Bulgaria
  {'label': 'BFA (+226)', 'value': '+226'}, // Burkina Faso
  {'label': 'MMR (+95)', 'value': '+95'}, // Myanmar (Burma)
  {'label': 'BDI (+257)', 'value': '+257'}, // Burundi
  {'label': 'KHM (+855)', 'value': '+855'}, // Cambodia
  {'label': 'CMR (+237)', 'value': '+237'}, // Cameroon
  {'label': 'CAN (+1)', 'value': '+1'}, // Canada
  {'label': 'CPV (+238)', 'value': '+238'}, // Cape Verde
  {'label': 'CYM (+1345)', 'value': '+1345'}, // Cayman Islands
  {'label': 'CAF (+236)', 'value': '+236'}, // Central African Republic
  {'label': 'TCD (+235)', 'value': '+235'}, // Chad
  {'label': 'CHL (+56)', 'value': '+56'}, // Chile
  {'label': 'CHN (+86)', 'value': '+86'}, // China
  {'label': 'CXR (+61)', 'value': '+61'}, // Christmas Island
  {'label': 'CCK (+61)', 'value': '+61'}, // Cocos (Keeling) Islands
  {'label': 'COL (+57)', 'value': '+57'}, // Colombia
  {'label': 'COM (+269)', 'value': '+269'}, // Comoros
  {'label': 'COG (+242)', 'value': '+242'}, // Congo (Brazzaville)
  {'label': 'COD (+243)', 'value': '+243'}, // Congo (Kinshasa)
  {'label': 'COK (+682)', 'value': '+682'}, // Cook Islands
  {'label': 'CRI (+506)', 'value': '+506'}, // Costa Rica
  {'label': 'HRV (+385)', 'value': '+385'}, // Croatia
  {'label': 'CUB (+53)', 'value': '+53'}, // Cuba
  {'label': 'CUW (+599)', 'value': '+599'}, // Curaçao
  {'label': 'CYP (+357)', 'value': '+357'}, // Cyprus
  {'label': 'CZE (+420)', 'value': '+420'}, // Czech Republic
  {'label': 'DNK (+45)', 'value': '+45'}, // Denmark
  {'label': 'DJI (+253)', 'value': '+253'}, // Djibouti
  {'label': 'DMA (+1767)', 'value': '+1767'}, // Dominica
  {'label': 'DOM (+1809)', 'value': '+1809'}, // Dominican Republic
  {'label': 'DOM (+1829)', 'value': '+1829'}, // Dominican Republic
  {'label': 'DOM (+1849)', 'value': '+1849'}, // Dominican Republic
  {'label': 'TLS (+670)', 'value': '+670'}, // East Timor
  {'label': 'ECU (+593)', 'value': '+593'}, // Ecuador
  {'label': 'EGY (+20)', 'value': '+20'}, // Egypt
  {'label': 'SLV (+503)', 'value': '+503'}, // El Salvador
  {'label': 'GNQ (+240)', 'value': '+240'}, // Equatorial Guinea
  {'label': 'ERI (+291)', 'value': '+291'}, // Eritrea
  {'label': 'EST (+372)', 'value': '+372'}, // Estonia
  {'label': 'ETH (+251)', 'value': '+251'}, // Ethiopia
  {'label': 'FLK (+500)', 'value': '+500'}, // Falkland Islands
  {'label': 'FRO (+298)', 'value': '+298'}, // Faroe Islands
  {'label': 'FJI (+679)', 'value': '+679'}, // Fiji
  {'label': 'FIN (+358)', 'value': '+358'}, // Finland
  {'label': 'FRA (+33)', 'value': '+33'}, // France
  {'label': 'PYF (+689)', 'value': '+689'}, // French Polynesia
  {'label': 'GAB (+241)', 'value': '+241'}, // Gabon
  {'label': 'GMB (+220)', 'value': '+220'}, // Gambia
  {'label': 'GEO (+995)', 'value': '+995'}, // Georgia
  {'label': 'DEU (+49)', 'value': '+49'}, // Germany
  {'label': 'GHA (+233)', 'value': '+233'}, // Ghana
  {'label': 'GIB (+350)', 'value': '+350'}, // Gibraltar
  {'label': 'GRC (+30)', 'value': '+30'}, // Greece
  {'label': 'GRL (+299)', 'value': '+299'}, // Greenland
  {'label': 'GRD (+1473)', 'value': '+1473'}, // Grenada
  {'label': 'GUM (+1671)', 'value': '+1671'}, // Guam
  {'label': 'GTM (+502)', 'value': '+502'}, // Guatemala
  {'label': 'GGY (+441481)', 'value': '+441481'}, // Guernsey
  {'label': 'GIN (+224)', 'value': '+224'}, // Guinea
  {'label': 'GNB (+245)', 'value': '+245'}, // Guinea-Bissau
  {'label': 'GUY (+592)', 'value': '+592'}, // Guyana
  {'label': 'HTI (+509)', 'value': '+509'}, // Haiti
  {'label': 'HND (+504)', 'value': '+504'}, // Honduras
  {'label': 'HKG (+852)', 'value': '+852'}, // Hong Kong
  {'label': 'HUN (+36)', 'value': '+36'}, // Hungary
  {'label': 'ISL (+354)', 'value': '+354'}, // Iceland
  {'label': 'IND (+91)', 'value': '+91'}, // India
  {'label': 'IDN (+62)', 'value': '+62'}, // Indonesia
  {'label': 'IRN (+98)', 'value': '+98'}, // Iran
  {'label': 'IRQ (+964)', 'value': '+964'}, // Iraq
  {'label': 'IRL (+353)', 'value': '+353'}, // Ireland
  {'label': 'IMN (+441624)', 'value': '+441624'}, // Isle of Man
  {'label': 'ISR (+972)', 'value': '+972'}, // Israel
  {'label': 'ITA (+39)', 'value': '+39'}, // Italy
  {'label': 'CIV (+225)', 'value': '+225'}, // Ivory Coast
  {'label': 'JAM (+1876)', 'value': '+1876'}, // Jamaica
  {'label': 'JPN (+81)', 'value': '+81'}, // Japan
  {'label': 'JEY (+441534)', 'value': '+441534'}, // Jersey
  {'label': 'JOR (+962)', 'value': '+962'}, // Jordan
  {'label': 'KAZ (+7)', 'value': '+7'}, // Kazakhstan
  {'label': 'KEN (+254)', 'value': '+254'}, // Kenya
  {'label': 'KIR (+686)', 'value': '+686'}, // Kiribati
  {'label': 'XKX (+383)', 'value': '+383'}, // Kosovo
  {'label': 'KWT (+965)', 'value': '+965'}, // Kuwait
  {'label': 'KGZ (+996)', 'value': '+996'}, // Kyrgyzstan
  {'label': 'LAO (+856)', 'value': '+856'}, // Laos
  {'label': 'LVA (+371)', 'value': '+371'}, // Latvia
  {'label': 'LBN (+961)', 'value': '+961'}, // Lebanon
  {'label': 'LSO (+266)', 'value': '+266'}, // Lesotho
  {'label': 'LBR (+231)', 'value': '+231'}, // Liberia
  {'label': 'LBY (+218)', 'value': '+218'}, // Libya
  {'label': 'LIE (+423)', 'value': '+423'}, // Liechtenstein
  {'label': 'LTU (+370)', 'value': '+370'}, // Lithuania
  {'label': 'LUX (+352)', 'value': '+352'}, // Luxembourg
  {'label': 'MAC (+853)', 'value': '+853'}, // Macau
  {'label': 'MKD (+389)', 'value': '+389'}, // North Macedonia
  {'label': 'MDG (+261)', 'value': '+261'}, // Madagascar
  {'label': 'MWI (+265)', 'value': '+265'}, // Malawi
  {'label': 'MYS (+60)', 'value': '+60'}, // Malaysia
  {'label': 'MDV (+960)', 'value': '+960'}, // Maldives
  {'label': 'MLI (+223)', 'value': '+223'}, // Mali
  {'label': 'MLT (+356)', 'value': '+356'}, // Malta
  {'label': 'MHL (+692)', 'value': '+692'}, // Marshall Islands
  {'label': 'MRT (+222)', 'value': '+222'}, // Mauritania
  {'label': 'MUS (+230)', 'value': '+230'}, // Mauritius
  {'label': 'MYT (+262)', 'value': '+262'}, // Mayotte
  {'label': 'MEX (+52)', 'value': '+52'}, // Mexico
  {'label': 'FSM (+691)', 'value': '+691'}, // Micronesia
  {'label': 'MDA (+373)', 'value': '+373'}, // Moldova
  {'label': 'MCO (+377)', 'value': '+377'}, // Monaco
  {'label': 'MNG (+976)', 'value': '+976'}, // Mongolia
  {'label': 'MNE (+382)', 'value': '+382'}, // Montenegro
  {'label': 'MSR (+1664)', 'value': '+1664'}, // Montserrat
  {'label': 'MAR (+212)', 'value': '+212'}, // Morocco
  {'label': 'MOZ (+258)', 'value': '+258'}, // Mozambique
  {'label': 'NAM (+264)', 'value': '+264'}, // Namibia
  {'label': 'NRU (+674)', 'value': '+674'}, // Nauru
  {'label': 'NPL (+977)', 'value': '+977'}, // Nepal
  {'label': 'NLD (+31)', 'value': '+31'}, // Netherlands
  {'label': 'ANT (+599)', 'value': '+599'}, // Netherlands Antilles
  {'label': 'NCL (+687)', 'value': '+687'}, // New Caledonia
  {'label': 'NZL (+64)', 'value': '+64'}, // New Zealand
  {'label': 'NIC (+505)', 'value': '+505'}, // Nicaragua
  {'label': 'NER (+227)', 'value': '+227'}, // Niger
  {'label': 'NGA (+234)', 'value': '+234'}, // Nigeria
  {'label': 'NIU (+683)', 'value': '+683'}, // Niue
  {'label': 'MNP (+1670)', 'value': '+1670'}, // Northern Mariana Islands
  {'label': 'PRK (+850)', 'value': '+850'}, // North Korea
  {'label': 'NOR (+47)', 'value': '+47'}, // Norway
  {'label': 'OMN (+968)', 'value': '+968'}, // Oman
  {'label': 'PAK (+92)', 'value': '+92'}, // Pakistan
  {'label': 'PLW (+680)', 'value': '+680'}, // Palau
  {'label': 'PSE (+970)', 'value': '+970'}, // Palestine
  {'label': 'PAN (+507)', 'value': '+507'}, // Panama
  {'label': 'PNG (+675)', 'value': '+675'}, // Papua New Guinea
  {'label': 'PRY (+595)', 'value': '+595'}, // Paraguay
  {'label': 'PER (+51)', 'value': '+51'}, // Peru
  {'label': 'PHL (+63)', 'value': '+63'}, // Philippines
  {'label': 'PCN (+64)', 'value': '+64'}, // Pitcairn Islands
  {'label': 'POL (+48)', 'value': '+48'}, // Poland
  {'label': 'PRT (+351)', 'value': '+351'}, // Portugal
  {'label': 'PRI (+1787)', 'value': '+1787'}, // Puerto Rico
  {'label': 'PRI (+1939)', 'value': '+1939'}, // Puerto Rico
  {'label': 'QAT (+974)', 'value': '+974'}, // Qatar
  {'label': 'REU (+262)', 'value': '+262'}, // Réunion
  {'label': 'ROU (+40)', 'value': '+40'}, // Romania
  {'label': 'RUS (+7)', 'value': '+7'}, // Russia
  {'label': 'RWA (+250)', 'value': '+250'}, // Rwanda
  {'label': 'BLM (+590)', 'value': '+590'}, // Saint Barthélemy
  {'label': 'WSM (+685)', 'value': '+685'}, // Samoa
  {'label': 'SMR (+378)', 'value': '+378'}, // San Marino
  {'label': 'STP (+239)', 'value': '+239'}, // São Tomé and Príncipe
  {'label': 'SAU (+966)', 'value': '+966'}, // Saudi Arabia
  {'label': 'SEN (+221)', 'value': '+221'}, // Senegal
  {'label': 'SRB (+381)', 'value': '+381'}, // Serbia
  {'label': 'SYC (+248)', 'value': '+248'}, // Seychelles
  {'label': 'SLE (+232)', 'value': '+232'}, // Sierra Leone
  {'label': 'SGP (+65)', 'value': '+65'}, // Singapore
  {'label': 'SXM (+1721)', 'value': '+1721'}, // Sint Maarten
  {'label': 'SVK (+421)', 'value': '+421'}, // Slovakia
  {'label': 'SVN (+386)', 'value': '+386'}, // Slovenia
  {'label': 'SLB (+677)', 'value': '+677'}, // Solomon Islands
  {'label': 'SOM (+252)', 'value': '+252'}, // Somalia
  {'label': 'ZAF (+27)', 'value': '+27'}, // South Africa
  {'label': 'KOR (+82)', 'value': '+82'}, // South Korea
  {'label': 'SSD (+211)', 'value': '+211'}, // South Sudan
  {'label': 'ESP (+34)', 'value': '+34'}, // Spain
  {'label': 'LKA (+94)', 'value': '+94'}, // Sri Lanka
  {'label': 'SHN (+290)', 'value': '+290'}, // Saint Helena
  {'label': 'KNA (+1869)', 'value': '+1869'}, // Saint Kitts
  {'label': 'LCA (+1758)', 'value': '+1758'}, // Saint Lucia
  {'label': 'MAF (+590)', 'value': '+590'}, // Saint Martin
  {'label': 'SPM (+508)', 'value': '+508'}, // Saint Pierre and Miquelon
  {'label': 'VCT (+1784)', 'value': '+1784'}, // Saint Vincent and the Grenadines
  {'label': 'SDN (+249)', 'value': '+249'}, // Sudan
  {'label': 'SUR (+597)', 'value': '+597'}, // Suriname
  {'label': 'SJM (+47)', 'value': '+47'}, // Svalbard and Jan Mayen
  {'label': 'SWZ (+268)', 'value': '+268'}, // Eswatini
  {'label': 'SWE (+46)', 'value': '+46'}, // Sweden
  {'label': 'CHE (+41)', 'value': '+41'}, // Switzerland
  {'label': 'SYR (+963)', 'value': '+963'}, // Syria
  {'label': 'TWN (+886)', 'value': '+886'}, // Taiwan
  {'label': 'TJK (+992)', 'value': '+992'}, // Tajikistan
  {'label': 'TZA (+255)', 'value': '+255'}, // Tanzania
  {'label': 'THA (+66)', 'value': '+66'}, // Thailand
  {'label': 'TGO (+228)', 'value': '+228'}, // Togo
  {'label': 'TKL (+690)', 'value': '+690'}, // Tokelau
  {'label': 'TON (+676)', 'value': '+676'}, // Tonga
  {'label': 'TTO (+1868)', 'value': '+1868'}, // Trinidad and Tobago
  {'label': 'TUN (+216)', 'value': '+216'}, // Tunisia
  {'label': 'TUR (+90)', 'value': '+90'}, // Turkey
  {'label': 'TKM (+993)', 'value': '+993'}, // Turkmenistan
  {'label': 'TCA (+1649)', 'value': '+1649'}, // Turks and Caicos Islands
  {'label': 'TUV (+688)', 'value': '+688'}, // Tuvalu
  {'label': 'ARE (+971)', 'value': '+971'}, // United Arab Emirates
  {'label': 'UGA (+256)', 'value': '+256'}, // Uganda
  {'label': 'GBR (+44)', 'value': '+44'}, // United Kingdom
  {'label': 'UKR (+380)', 'value': '+380'}, // Ukraine
  {'label': 'URY (+598)', 'value': '+598'}, // Uruguay
  {'label': 'USA (+1)', 'value': '+1'}, // United States
  {'label': 'UZB (+998)', 'value': '+998'}, // Uzbekistan
  {'label': 'VUT (+678)', 'value': '+678'}, // Vanuatu
  {'label': 'VAT (+379)', 'value': '+379'}, // Vatican City
  {'label': 'VEN (+58)', 'value': '+58'}, // Venezuela
  {'label': 'VNM (+84)', 'value': '+84'}, // Vietnam
  {'label': 'VIR (+1340)', 'value': '+1340'}, // U.S. Virgin Islands
  {'label': 'WLF (+681)', 'value': '+681'}, // Wallis and Futuna
  {'label': 'ESH (+212)', 'value': '+212'}, // Western Sahara
  {'label': 'YEM (+967)', 'value': '+967'}, // Yemen
  {'label': 'ZMB (+260)', 'value': '+260'}, // Zambia
  {'label': 'ZWE (+263)', 'value': '+263'}, // Zimbabwe
];
