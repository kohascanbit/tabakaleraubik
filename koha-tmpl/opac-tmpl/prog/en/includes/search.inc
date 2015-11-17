[% IF ( OpacPublic ) %]
    <div id="opac_search">
        [% UNLESS ( advsearch ) %]<form name="searchform" method="get" action="/cgi-bin/koha/opac-search.pl" id="searchform">
             <input name="idx" value="Opac" type="hidden" />
            [% IF ( ms_value ) %]
                <input type="text" title="Type search term" id = "transl1" name="q" value="[% ms_value |html %]" class="left"/><div id="translControl"></div>
            [% ELSE %]
                <input type="text" title="Type search term" id = "transl1" name="q" class="left"/><div id="translControl"></div>
            [% END %]
	        [% IF ( opac_limit_override ) %]
	            [% IF ( opac_search_limit ) %]
	                <input name="limit" value="[% opac_search_limit %]" type="hidden" />
	            [% END %]
	        [% ELSE %]
	            [% IF ( mylibraryfirst ) %] 
	                <input name="limit" value="branch:[% mylibraryfirst %]" type="hidden" />
	            [% END %]
	        [% END %]

            
            <button type="submit" id="searchiconsubmit" class="left"></button>
            [% IF ( opacbookbag ) %]<span id="cmspan"></span>[% END %]
            [% IF ( virtualshelves ) %]<a href="/cgi-bin/koha/opac-shelves.pl" id="listsmenulink" class=""><i></i><span><i></i><span></span>Lists </span></a>[% END %]
            </form>
        [% ELSE %]
            <div style="width:80%;*margin-bottom:-30px;">
            [% IF ( virtualshelves ) %]<a href="/cgi-bin/koha/opac-shelves.pl" id="listsmenulink" class=""><i></i><span><i></i><span></span>Lists </span></a>[% END %]
            [% IF ( opacbookbag ) %]<span id="cmspan"></span>[% END %]
            </div>
        [% END %]
    </div>
[% END %]
