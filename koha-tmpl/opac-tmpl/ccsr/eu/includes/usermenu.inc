[% IF ( opacuserlogin ) %][% IF ( loggedinusername ) %] <div id="menu">
<ul>
 [% IF ( userview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-user.pl">nire laburpena</a></li>
 [% IF ( OPACFinesTab ) %] [% IF ( accountview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-account.pl">nire isunak</a></li>
 [% END %] [% IF ( userupdateview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-memberentry.pl">nire datu pertsonalak</a></li>
 [% IF ( TagsEnabled ) %] [% IF ( tagsview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-tags.pl?mine=1">nire etiketak</a></li>
 [% END %] [% IF ( OpacPasswordChange ) %] [% IF ( passwdview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-passwd.pl">nire pasahitza aldatu</a></li>
 [% END %] [% IF ( ShowOpacRecentSearchLink ) %] [% IF ( searchhistoryview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-search-history.pl">nire bilaketa-historiala</a></li>
 [% END %] [% IF ( opacreadinghistory ) %] [% IF ( readingrecview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-readingrecord.pl">nire irakurketa-historiala</a></li>
 [% IF ( OPACPrivacy ) %] [% IF ( privacyview ) %]<li class="active">[% ELSE %]<li>[% END %]<a href="/cgi-bin/koha/opac-privacy.pl">nire pribatutasuna</a></li>
 [% END %] [% END %] [% IF ( suggestion ) %] [% UNLESS ( AnonSuggestions ) %] [% IF ( suggestionsview ) %]<li class="active suggestions">[% ELSE %]<li class="suggestions">[% END %]<a href="/cgi-bin/koha/opac-suggestions.pl">nire erosketa-iradokizunak</a></li>
 [% END %] [% END %] [% IF ( EnhancedMessagingPreferences ) %] [% IF ( messagingview ) %]<li class="active messaging">[% ELSE %]<li class="messaging">[% END %]<a href="/cgi-bin/koha/opac-messaging.pl">nire mezularitza</a></li>
 [% END %] [% IF ( virtualshelves ) %] [% IF ( listsview ) %]<li class="active privateshelves">[% ELSE %]<li class="privateshelves">[% END %]<a href="/cgi-bin/koha/opac-shelves.pl?display=privateshelves">nire zerrendak</a></li>
 [% END %] </ul>
</div>
[% END %][% ELSE %][% END %] 