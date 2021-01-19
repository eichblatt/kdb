\d .dt

/ timezones : Download from https://timezonedb.com
/ data files: 
/  country.csv : Fields: "country_code","country_name"
/  timezone.csv: Fields: "zone_id","abbreviation","time_start","gmt_offset","dst"
/  zone.csv: Fields: "zone_id","country_code","zone_name"

.dt.tzdbpath:.file.makepath[getenv`HOME;"data/tz"];

get_tzdb:{[] 
   if[`tzdb in key .dt;:.dt.tzdb];
   country:flip `country`country_name!("SS";csv)0:.file.makepath[.dt.tzdbpath;"country.csv"];
   timezone:flip `zone_id`tz_code`time_start`gmt_offset`dst!("ISZIB";csv)0:.file.makepath[.dt.tzdbpath;"timezone.csv"];
   zone:flip `zone_id`country_code`tz!("ISS";csv)0:.file.makepath[.dt.tzdbpath;"zone.csv"];
   .dt.tzdb:`time_start xasc select tz,time_start,gmt_offset from (timezone lj 1!zone) where not null time_start;
   .dt.tzdb};

convert_tz:{[dt;tz_from;tz_to]
   dtype:.Q.ty[dt];
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
