[% IF ( opacfacets ) %]
[% IF ( facets_loop ) %]
<div id="facets">
[% UNLESS ( advsearch ) %]
	<div id="left_search">
  [% IF ( OpacPublic ) %]
  <form name="searchform" method="get" action="/cgi-bin/koha/opac-search-filmoteca.pl" id="searchform">
    <h4 class="new_search">New search</h4>
    <label for="masthead_search" class="left"> Search 
	[% UNLESS ( OpacAddMastheadLibraryPulldown ) %]
            [% IF ( mylibraryfirst ) %] (in [% mylibraryfirst %] only)[% END %]
	[% END %]
    </label>
	<select name="idx" id="masthead_search" class="left">
	[% IF ( ms_kw ) %]
        <option selected="selected" value="">Library Catalog</option>
		[% ELSE %]
        <option value="">Library Catalog</option>
		[% END %]
		[% IF ( ms_ti ) %]
        <option selected="selected" value="ti">Title</option>
		[% ELSE %]
        <option value="ti">Title</option>
		[% END %]
		[% IF ( ms_au ) %]
        <option selected="selected" value="au">Author</option>
		[% ELSE %]
        <option value="au">Author</option>
		[% END %]
		[% IF ( ms_su ) %]
        <option selected="selected" value="su">Subject</option>
		[% ELSE %]
        <option value="su">Subject</option>
		[% END %]
		[% IF ( ms_nb ) %]
		<option selected="selected" value="nb">ISBN</option>
		[% ELSE %]
		<option value="nb">ISBN</option>
		[% END %]
		[% IF ( ms_se ) %]
        <option selected="selected" value="se">Series</option>
		[% ELSE %]
        <option value="se">Series</option>
		[% END %]
		[% IF ( ms_callnum ) %]
        <option selected="selected" value="callnum">Call Number</option>
		[% ELSE %]
        <option value="callnum">Call Number</option>
		[% END %]</select>
[% IF ( ms_value ) %]
        <input type="text" id = "transl1" name="q" value="[% ms_value |html %]" class="left"/><div id="translControl"></div>
[% ELSE %]
        <input type="text" id = "transl1" name="q" class="left"/><div id="translControl"></div>
[% END %]
    <input name="limit" value="branch:FIL" type="hidden" />
    <input type="submit" value="Go" id="searchsubmit" class="left" />
    </form>
  </div>
[% END %]
<div id="search-facets">
<h4>Refine your search</h4>
<ul>
	<!-- <li>Availability
	<ul>
	<li>
	[% IF ( available ) %]Showing only <strong>available</strong> items. <a href="/cgi-bin/koha/opac-search-filmoteca.pl?[% query_cgi |html %][% limit_cgi_not_availablity %][% IF ( sort_by ) %]&amp;sort_by=[% sort_by |html%][% END %]">Show all items</a>
	[% ELSE %]Limit to <a href="/cgi-bin/koha/opac-search-filmoteca.pl?[% query_cgi |html %][% limit_cgi |html %][% IF ( sort_by ) %]&amp;sort_by=[% sort_by |html%][% END %]&amp;limit=available">currently available items.</a>
	[% END %]
	</li> 
	</ul>
	[% IF ( related ) %] 
	<li>(related searches: 
	[% FOREACH relate IN related %]
	[% relate.related_search %]
	[% END %])
	</li>
	[% END %]
	</li>-->
	
[% FOREACH facets_loo IN facets_loop %]
[% UNLESS ( facets_loo.type_label_Libraries ) %]
<li id="[% facets_loo.type_id %]">
[% IF ( facets_loo.type_label_Authors ) %]Authors[% END %]
[% IF ( facets_loo.type_label_Titles ) %]Titles[% END %]
[% IF ( facets_loo.type_label_Topics ) %]Topics[% END %]
[% IF ( facets_loo.type_label_Places ) %]Places[% END %]
[% IF ( facets_loo.type_label_Series ) %]Series[% END %]
[% IF ( facets_loo.type_label_ItemTypes ) %]Item types[% END %]
[% UNLESS ( singleBranchMode ) %]
[% IF ( facets_loo.type_label_Libraries ) %]Libraries[% END %]
[% END %]
[% IF ( facets_loo.type_label_Location ) %]Locations[% END %]
<ul>

        [% FOREACH facet IN facets_loo.facets %]
        <li><a href="/cgi-bin/koha/opac-search-filmoteca.pl?[% query_cgi |html %][% limit_cgi |html %][% IF ( sort_by ) %]&amp;sort_by=[% sort_by |html %][% END %]&amp;limit=[% facet.type_link_value %]:[% facet.facet_link_value %]" title="[% facet.facet_title_value |html %]">[% facet.facet_label_value %]</a> 
        [% IF ( displayFacetCount ) %]([% facet.facet_count %])[% END %]
        </li>
        [% END %]
        [% IF ( facets_loo.expandable ) %]
        <li class="showmore">
        <a href="/cgi-bin/koha/opac-search-filmoteca.pl?[% query_cgi |html %][% limit_cgi |html %][% IF ( sort_by ) %]&amp;sort_by=[% sort_by |html %][% END %][% IF ( offset ) %]&amp;offset=[% offset %][% END %]&amp;expand=[% facets_loo.expand %]#[% facets_loo.type_id %]">Show more</a>
        </li>
[% END %]
</ul></li>
[% END %]
[% END %]
</ul>
</div>
[% IF ( OPACResultsSidebar ) %]
<div id="opacresultssidebar">
[% OPACResultsSidebar %]
</div>
[% END %]
[% END %]
[% END %]
[% END %]
