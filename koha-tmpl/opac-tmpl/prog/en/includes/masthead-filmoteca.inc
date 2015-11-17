<div id="header-wrapper"><div id="members">
  [% IF ( opacuserlogin ) %]
	<ul>
            [% IF ( ShowOpacRecentSearchLink ) %]
                <li><a href="/cgi-bin/koha/opac-search-history-filmoteca.pl" title="View your search history">Search history</a> [<a class="logout" href="/cgi-bin/koha/opac-search-history.pl?action=delete" title="Delete your search history" onclick="return confirm(MSG_DELETE_SEARCH_HISTORY);">x</a>]</li>
            [% END %]
   	</ul>	
  [% END %]
</div>
<div class="filmoteca">
<strong>EUSKADIKO FILMATEGIA - FILMOTECA VASCA Catalog</strong>
</div>
[% IF ( opaclanguagesdisplay ) %]
    [% IF ( languages_loop && opaclanguagesdisplay ) %]
        [% UNLESS ( one_language_enabled ) %]
            <div id="changelanguage" class="ft">
            <div class="lang"><strong>Languages:&nbsp;</strong></div>
            <ul id="i18nMenu" class="footermenu">
            [% FOREACH languages_loo IN languages_loop %]

                [% IF ( languages_loo.group_enabled ) %]
                [% IF ( languages_loo.plural ) %]
                <li class="more"><a class="sublangs" id="show[% languages_loo.rfc4646_subtag %]" href="#">[% IF ( languages_loo.native_description ) %][% languages_loo.native_description %][% ELSE %][% languages_loo.rfc4646_subtag %][% END %]</a><div id="sub[% languages_loo.rfc4646_subtag %]">
                <div class="bd"><ul>
                [% FOREACH sublanguages_loo IN languages_loo.sublanguages_loop %]
            [% IF ( sublanguages_loo.enabled ) %]
                    [% IF ( sublanguages_loo.sublanguage_current ) %]
                        <li> [% sublanguages_loo.native_description %] [% sublanguages_loo.script_description %] [% sublanguages_loo.region_description %] [% sublanguages_loo.variant_description %] ([% sublanguages_loo.rfc4646_subtag %])</li>
                    [% ELSE %]
                    <li><a href="/cgi-bin/koha/opac-changelanguage-filmoteca.pl?language=[% sublanguages_loo.rfc4646_subtag %]"> [% sublanguages_loo.native_description %] [% sublanguages_loo.script_description %] [% sublanguages_loo.region_description %] [% sublanguages_loo.variant_description %] ([% sublanguages_loo.rfc4646_subtag %])</a></li>
            [% END %]
                    [% END %]

                [% END %]
                </ul></div></div></li>

                [% ELSE %]
                [% IF ( languages_loo.group_enabled ) %]
                    [% IF ( languages_loo.current ) %]
                        <li class="morelang">[% IF ( languages_loo.native_description ) %][% languages_loo.native_description %][% ELSE %][% languages_loo.rfc4646_subtag %][% END %]</li>
                    [% ELSE %]
                        <li class="morelang"><a href="/cgi-bin/koha/opac-changelanguage-filmoteca.pl?language=[% languages_loo.rfc4646_subtag %]">[% IF ( languages_loo.native_description ) %][% languages_loo.native_description %][% ELSE %][% languages_loo.rfc4646_subtag %][% END %]</a></li>
                    [% END %]
            [% END %]
                [% END %]
                [% END %]

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
<h1 id="libraryname" >
<a href="/cgi-bin/koha/opac-main-filmoteca.pl" title="filmoteca"><img src="/opac-tmpl/prog/images/fim1.jpg" alt="EUSKADIKO FILMATEGIA - FILMOTECA VASCA" />
<span>EUSKADIKO FILMATEGIA - FILMOTECA VASCA</span></a></h1>
<div id="fluid">

[% IF ( OpacPublic ) %]
<div id="fluid-offset">

<div id="moresearches">
<a href="/cgi-bin/koha/opac-search-filmoteca.pl">Advanced search</a>
[% IF ( OpacTopissue ) %]<span class="pipe"> | </span><a href="/cgi-bin/koha/opac-topissues-filmoteca.pl">Most popular</a>[% END %]
</div>
 </div>
</div>

[% END %]  <!-- OpacPublic --> 

[% IF ( opacbookbag ) %]<div id="cartDetails">Your cart is empty.</div>[% END %]



</div>
</div>
