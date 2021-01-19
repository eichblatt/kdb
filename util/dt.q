\d .dt

/ timezones : Download from https://timezonedb.com
/ data files: 
/  country.csv : Fields: "country_code","country_name"
/  timezone.csv: Fields: "zone_id","abbreviation","time_start","gmt_offset","dst"
/  zone.csv: Fields: "zone_id","country_code","zone_name"

.dt.tzdbpath:.file.makepath[getenv`HOME;"data/tz"];

get_tzdb:{[] 
   if[`tzdb in key .dt;:.dt.tzdb];
   if[not .file.exists[.dt.tzdbpath]; .log.error .string.format["TZ database missing. Download from https://timezonedb.com, and place in %p%";(`p;.dt.tzdbpath)]];
   /country:flip `country`country_name!("SS";csv)0:.file.makepath[.dt.tzdbpath;"country.csv"]; // not used.
   timezone:flip `zone_id`tz_code`time_start`gmt_offset`dst!("ISZIB";csv)0:.file.makepath[.dt.tzdbpath;"timezone.csv"];
   zone:flip `zone_id`country_code`tz!("ISS";csv)0:.file.makepath[.dt.tzdbpath;"zone.csv"];
   .dt.tzdb:select tz,time_start,gmt_offset from (timezone lj 1!zone) where not null time_start;
   .dt.tzdb:.dt.tzdb,update tz:`est from select from (.dt.tzdb) where tz=`$"America/New_York";   // Add `est for convenience
   .dt.tzdb:.dt.tzdb,update tz:`qst,gmt_offset:gmt_offset+7*3600 from select from (.dt.tzdb) where tz=`$"America/New_York"; // qst midnight is global market close
   .dt.tzdb:.dt.tzdb,update tz:`utc,gmt_offset:0 from 1#select from .dt.tzdb where time_start=min time_start; // utc
   .dt.tzdb:`time_start xasc .dt.tzdb; 
   .dt.tzdb};

convert_tz:{[dt;tz_from;tz_to]
   dtype:.Q.ty[dt];
   if[not dtype in "ZzPp"; .log.error "datetime argument must be of type Z or P"; '"invalid dt format"];
   offset_fromd:`s#exec time_start!gmt_offset from .dt.get_tzdb[] where tz=tz_from;
   offset_tod:  `s#exec time_start!gmt_offset from .dt.get_tzdb[] where tz=tz_to;
   
   offset_from:offset_fromd[dt];
   offset_to:offset_tod[dt];
   delta_time:offset_to-offset_from;
   delta_time:$[dtype in "Zz";delta_time%24*3600;dtype in "Pp";"j"$1e9*delta_time;delta_time]; // in days for Z, in nanoseconds for P.
   dt_out:dt+delta_time;
   dt_out}
/
parms:.opts.get_opts[c]
\
