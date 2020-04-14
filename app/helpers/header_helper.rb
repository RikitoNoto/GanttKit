module HeaderHelper
    def get_header_new_path(hope_path)#workの中にいたらworkにネストされたパスを返す
        work_path = /^\/works\/\d+/
        regexp = request.path_info.scan(work_path)
        if regexp.length != 0
            return "#{regexp[0]}/#{hope_path}/new"
        else
            return "/#{hope_path}/new"
        end
    end
end
