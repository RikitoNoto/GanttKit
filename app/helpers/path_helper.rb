module PathHelper
    # def get_header_new_path(hope_path)#workの中にいたらworkにネストされたパスを返す。それ以外は普通のnewパスを返す。hope_pathで受け取った文字列+newを返す。
    #     work_path = /^\/works\/\d+/
    #     regexp = request.path_info.scan(work_path)
    #     if regexp.length != 0
    #         return "#{regexp[0]}/#{hope_path}/new"
    #     else
    #         return "/#{hope_path}/new"
    #     end
    # end#prefexpathの第二オペランドにハッシュを入れるとparamsとして渡せるみたいなので現状使用しない

    def current_new_path(user: "ignore")#現在の位置から新規作成のパスを作成する。
        if request.path_info == "/"
            url = "/works/new"#ルートパスならwork#newに行くように
        else
            url = "#{request.path_info}/new"#users/1/works/ならusers/1/works/new
        end
        case user
        when "ignore"#userをurlに含めないなら(デフォルト)
            return url.sub(/\/users\/\d+/, "")
        when "include"
            return url #userを無視しないオプションなら
        end
    end
end
