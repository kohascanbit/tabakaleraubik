[% IF ( OpacPublic ) %]
    <div id="opac_search">
        [% UNLESS ( advsearch ) %]<form name="searchform" method="get" action="/cgi-bin/koha/opac-search-filmoteca.pl" id="searchform">
            <label for="masthead_search" class="left"> Search 
            [% UNLESS ( OpacAddMastheadLibraryPulldown ) %]
                    [% IF ( mylibraryfirst ) %] (in [% mylibraryfirst %] only)[% END %]
            [% END %]
            </label>
            <select name="idx" id="masthead_search" class="left">
                [% IF ( ms_kw ) %]
                    <option selected="selected" value="">Library catalog</option>
                [% ELSE %]
                    <option value="">Library catalog</option>
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
                [% IF ( numbersphr ) %]
                    [% IF ( ms_callnum ) %]
                        <option selected="selected" value="callnum,phr">Call number</option>
                    [% ELSE %]
                        <option value="callnum,phr">Call number</option>
                    [% END %]
                [% ELSE %]
                    [% IF ( ms_callnum ) %]
                        <option selected="selected" value="callnum">Call number</option>
                    [% ELSE %]
                        <option value="callnum">Call number</option>
                    [% END %]
                [% END %]
            </select>
            [% IF ( ms_value ) %]
                <input type="text" title="Type search term" id = "transl1" name="q" value="[% ms_value |html %]" class="left" style="width: 35%; font-size: 111%;"/><div id="translControl"></div>
            [% ELSE %]
                <input type="text" title="Type search term" id = "transl1" name="q" class="left" style="width: 35%; font-size: 111%;"/><div id="translControl"></div>
            [% END %]
            <input name="limit" value="branch:FIL" type="hidden" />
            <input type="submit" value="Go" id="searchsubmit" class="left" />
            [% IF ( opacbookbag ) %]<span id="cmspan"></span>[% END %]
            </form>
        [% ELSE %]
            <div style="width:80%;*margin-bottom:-30px;">
            [% IF ( opacbookbag ) %]<span id="cmspan"></span>[% END %]
            </div>
        [% END %]
    </div>
[% END %]