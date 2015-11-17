<div id="header-wrapper"><div id="members">
  [% IF ( opacuserlogin ) %]
	<ul>
[% UNLESS ( loggedinusername ) %]
               <li><a href="/cgi-bin/koha/opac-user.pl">Log in to your account</a></li>[% END %]
            [% IF ( loggedinusername ) %]
                <li><span class="members">Welcome, <a href="/cgi-bin/koha/opac-user.pl"><span class="loggedinusername">[% FOREACH USER_INF IN USER_INFO %][% USER_INF.title %] [% USER_INF.firstname %] [% USER_INF.surname %][% END %]</span></a></span></li>

            [% END %]
            [% IF ( ShowOpacRecentSearchLink ) %]
                <li><a href="/cgi-bin/koha/opac-search-history.pl" title="View your search history">Search history</a> [<a class="logout" href="/cgi-bin/koha/opac-search-history.pl?action=delete" title="Delete your search history" onclick="return confirm(MSG_DELETE_SEARCH_HISTORY);">x</a>]</li>
            [% END %]
			[% IF ( loggedinusername ) %]<li>[% IF persona %]<a class="logout" id="logout" href="/cgi-bin/koha/opac-main.pl?logout.x=1" onclick='navigator.id.logout();'>[% ELSE %]<a class="logout" id="logout" href="/cgi-bin/koha/opac-main.pl?logout.x=1">[% END %]Log Out</a></li>[% END %]
	    <li>[% IF ( opacbookbag ) %]<span id="cmspan"></span>[% END %]</li>
   	</ul>	
  [% END %]
</div>
  [% IF ( opacheader ) %]
	[% opacheader %]
  [% END %]
[% IF ( opaclanguagesdisplay ) %]
    [% IF ( languages_loop && opaclanguagesdisplay ) %]
        [% UNLESS ( one_language_enabled ) %]
            <div id="changelanguage" class="ft">
            
            <ul class="footermenu" id="i18nMenu">
            	[% IF ( currentLanguage == 'eu' ) %]
                	<li class="morelang">Euskara</li>
                [% ELSE %]
                	 <li class="morelang"><a href="/cgi-bin/koha/opac-changelanguage.pl?language=eu">Euskara</a></li>
                [% END %]
                [% IF ( currentLanguage == 'es-ES' ) %]
                	<li class="morelang">Español</li>
                [% ELSE %]
                	 <li class="morelang"><a href="/cgi-bin/koha/opac-changelanguage.pl?language=es-ES">Español</a></li>
                [% END %]
                [% IF ( currentLanguage == 'en' ) %]
                	<li class="morelang">English</li>
                [% ELSE %]
                	 <li class="morelang"><a href="/cgi-bin/koha/opac-changelanguage.pl?language=en">English</a></li>
                [% END %]
            </ul>
            </div>
        [% END %]
    [% END %]

[% END %]

  <!-- TMPL_IF NAME="opacheader" -->
	<!-- TMPL_VAR NAME="opacheader" -->
  <!-- /TMPL_IF -->
<div id="opac-main-search" class="yui-g">
   [% IF ( opacsmallimage ) %]
   <h1 id="libraryname" ><span class="libraryActual"><a target="blank" href="http://kopac.tabakalera.eu" title="Tabakalera Catalog"><img src="[% opacsmallimage %]" alt="Tabakalera Catalog" />[% IF ( LibraryName ) %][% LibraryName %]<span>Catalog</span>[% ELSE %]<span>Koha Online Catalog</span>[% END %]</a></span>
   <span class="library"><a target="blank" title="Filmoteca Catalog" href="http://catalogo.filmotecavasca.com/">
		<img alt="Filmoteca Catalog" target="blank" src="http://kopac.tabakalera.eu/opac-tmpl/prog/images/filmoteca-icon.png" class="other">
		<span> Catalog</span>
		</a></span>
	</h1>
   
   [% ELSE %]
   <h1 id="libraryname">
   <a href="/cgi-bin/koha/opac-main.pl" title="[% IF ( LibraryName ) %][% LibraryName %][% ELSE %]Koha Online Catalog[% END %]">[% IF ( LibraryName ) %]<span>[% LibraryName %]</span>[% ELSE %]<span>Koha Online Catalog</span>[% END %]</a></h1>
   [% END %]
   [% IF ( opacsmallimageright ) %]
   <h1 id="librarylogo" ><a href="/cgi-bin/koha/opac-main.pl" ><img src="[% opacsmallimageright %]" alt="[% IF ( LibraryName ) %][% LibraryName %][% ELSE %]Koha Online Catalog[% END %]" /></a></h1>
   [% END %]

<div id="fluid">

[% IF ( OpacPublic ) %]
<div id="fluid-offset">

<div id="moresearches">
<a href="/cgi-bin/koha/opac-search.pl">Advanced search</a>
[% IF ( UseCourseReserves ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-course-reserves.pl">Course Reserves</a>[% END %]
[% IF ( OpacBrowser ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-browser.pl">Browse by hierarchy</a>[% END %]
[% IF ( OpacAuthorities ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-authorities-home.pl">Authority search</a>[% END %]
[% IF ( opacuserlogin && reviewson && OpacShowRecentComments ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-showreviews.pl">Recent comments</a>[% END %]
[% IF ( OpacCloud ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-tags_subject.pl">Subject cloud</a>[% END %]
[% IF ( OpacTopissue ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-topissues.pl">Most popular</a>[% END %]
[% IF ( suggestion ) %]
  [% IF ( AnonSuggestions ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-suggestions.pl">Purchase suggestions</a>
  [% ELSIF ( OPACViewOthersSuggestions ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-suggestions.pl">Purchase suggestions</a>
  [% END %]
[% END %]
</div>
 </div>
</div>

[% END %]  <!-- OpacPublic --> 

[% IF ( opacbookbag ) %]<div id="cartDetails">Your cart is empty.</div>[% END %]

[% IF ( virtualshelves ) %]
<div id="listsmenu" class="yuimenu" style="display: none">
    <div class="bd">
    <h4>Public lists</h4>
		[% IF ( pubshelves ) %]
			<ul class="first-of-type">
			[% FOREACH pubshelvesloo IN pubshelvesloop %]
			<li class="yuimenuitem"><a href="/cgi-bin/koha/opac-shelves.pl?viewshelf=[% pubshelvesloo.shelfnumber %]&amp;sortfield=[% pubshelvesloo.sortfield %]">[% pubshelvesloo.shelfname |html %]</a></li>
			[% END %]
			<li class="yuimenuitem"><a class="yuimenuitemlabel" href="/cgi-bin/koha/opac-shelves.pl?display=publicshelves">[View All]</a></li>
        </ul>
		[% ELSE %]
        No public lists
		[% END %]
  [% IF ( opacuserlogin ) %]
    <h4>Your lists</h4>
	[% IF ( loggedinusername ) %]
		[% IF ( barshelves ) %]
			<ul class="first-of-type">
			[% FOREACH barshelvesloo IN barshelvesloop %]
			<li class="yuimenuitem"><a href="/cgi-bin/koha/opac-shelves.pl?viewshelf=[% barshelvesloo.shelfnumber %]&amp;sortfield=[% barshelvesloo.sortfield %]">[% barshelvesloo.shelfname |html %]</a></li>
			[% END %]
        <li class="yuimenuitem"><a class="yuimenuitemlabel" href="/cgi-bin/koha/opac-shelves.pl?display=privateshelves">[View all]</a></li>
        </ul>
		[% ELSE %]
			<ul class="first-of-type">
        <li>No private lists</li>
        <li class="yuimenuitem"><a class="yuimenuitemlabel" href="/cgi-bin/koha/opac-shelves.pl?display=privateshelves">[New list]</a></li></ul>
		[% END %]
	[% ELSE %]
        <ul class="first-of-type"><li><a href="/cgi-bin/koha/opac-user.pl">Log in to create your own lists</a></li></ul>
	[% END %]
  [% END %]
	  </div>
</div><!-- /listmenu /virtualshelves -->
[% END %]
<div id="listsDetails"></div>
</div>
</div>
