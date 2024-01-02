module ExtractLinks

using AbstractTrees: PreOrderDFS
using Gumbo: HTMLElement, tag, parsehtml
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

function extract_links(body::AbstractString, root::AbstractString)

    startswith(root, r"https?://") || throw(ArgumentError("root must be an absolute URL starting with http:// or https://"))
    # resolvereference will silently misbehave if not.

    links = String[]
    for node in PreOrderDFS(parsehtml(body).root)
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
    for m in eachmatch(ExtractLinks.STRICT_REGEX, body)
        push!(links, m.match)
    end
    unique!(links)
end

end
