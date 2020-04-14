module PathHelper
    def get_header_new_path(hope_path)#workの中にいたらworkにネストされたパスを返す。それ以外は普通のnewパスを返す。hope_pathで受け取った文字列+newを返す。
        work_path = /^\/works\/\d+/
        regexp = request.path_info.scan(work_path)
        if regexp.length != 0
            return "#{regexp[0]}/#{hope_path}/new"
        else
            return "/#{hope_path}/new"
        end
    end

    def current_new_path#現在の位置から新規作成のパスを作成する。
        "#{request.path_info}/new"#user/1/works/ならuser/1/works/new
    end
end
