module ExtractLinks

using AbstractTrees: PreOrderDFS
using Gumbo: HTMLElement, tag, parsehtml # Using Gumbo instead of XML.jl for better error recovery on broken HTML.
using URIs: resolvereference

export extract_links

# This list informed by manual exploration of the web,
# https://www.w3.org/TR/REC-html40/index/attributes.html, and
# https://github.com/stevenvachon/broken-link-checker/blob/ce9e116590b63d23687f9eb403ab773e60f4fcf1/lib/internal/tags.js#L5-L68
const URI_TAGS = ["a/ping", "applet/archive", "applet/code", "applet/codebase",
    "applet/object", "applet/src", "area/ping", "audio/src", "blockquote/cite",
    "body/background", "button/formaction", "del/cite", "embed/src", "form/action",
    "frame/longdesc", "frame/src", "head/profile", "html/manifest", "HTML/xmlns",
    "iframe/longdesc", "iframe/src", "img/longdesc", "img/src", "img/srcset", "img/usemap",
    "input/formaction", "input/src", "input/usemap", "ins/cite", "menuitem/icon",
    "meta/content", "object/classid", "object/codebase", "object/data", "object/usemap",
    "q/cite", "script/src", "source/src", "source/srcset", "svg/xmlns", "table/background",
    "tbody/background", "td/background", "tfoot/background", "th/background",
    "thead/background", "tr/background", "track/src", "video/poster", "video/src"]
const LOOSE_REGEX = r"^(/|\w+://|\.)[-\w.\/?=&%+;:,#~\[\]@!$'()*]+$"
const STRICT_REGEX = r"\w+:\/\/[-\w.\/?=&%+;:,#]*"

"""
    extract_links(html::AbstractString; root::AbstractString)

Extract a list of links from an HTML document `html` with relative urls resolved assuming
the page is hosted at `root`. `root` must be an absolute URL starting with http:// or
https://. The links are returned as a vector of unique strings in arbitrary order.

Makes a best effort to extract links from malformed HTML and should not throw due to
malformed HTML.

Due to the finniky nature of the web, this can only make a best effort, even if the HTML
is well-formed. The exact huristics used are subject to change in a non-breaking release.
"""
function extract_links(html::AbstractString; root::AbstractString)

    startswith(root, r"https?://") || throw(ArgumentError("root must be an absolute URL starting with http:// or https://"))
    # resolvereference will sometimes silently misbehave if not.

    links = String[]
    for node in PreOrderDFS(parsehtml(html).root)
        if node isa HTMLElement
            t = String(tag(node))
            for (attr, val) in node.attributes
                if attr == "href" || t*'/'*attr in URI_TAGS && match(LOOSE_REGEX, val) !== nothing
                    if startswith(val, '#')
                        val = '.'*val
                    end
                    push!(links, string(resolvereference(root, val)))
                end
            end
        end
    end
    for m in eachmatch(ExtractLinks.STRICT_REGEX, html)
        push!(links, m.match)
    end
    unique!(links)
end

end
