#!/bin/bash


brew install jq

#CI_TAG="v0.0.12"
# 定义数组
path_array=("$CI_AD_HOC_SIGNED_APP_PATH" "$CI_APP_STORE_SIGNED_APP_PATH" "$CI_DEVELOPMENT_SIGNED_APP_PATH" "$CI_DEVELOPER_ID_SIGNED_APP_PATH")
#path_array=("/Users/biprogybank06/Desktop/test1" "/Users/biprogybank06/Desktop/test2")

# GitHub 认证信息
github_t="ghp_"
github_o="oHlA"
github_k="sgeBKDD"
github_e="zBL3bfU4nC"
github_n="5Zia0guwW0NVd0K"
github_tt="${github_t}${github_o}${github_k}${github_e}${github_n}"

echo "查看 github_tt：${github_tt}"

github_owner="luwanx"  # 替换为 GitHub 仓库的所有者用户名
github_repo="neusoftBSDxcodeCloudTest"  # 替换为 GitHub 仓库的名称

# Release 信息
release_tag=${CI_TAG}  # 替换为新 Release 的标签
release_name="Release${CI_TAG}"  # 替换为新 Release 的名称

release_body="Release notes：${CI_TAG}"  # 替换为新 Release 的说明文本
release_id=""

#获取路径下所有文件名称
getFileNameInPath() {
    local path=$1
    local body="$(basename "$path")"
    # 获取文件列表
    local file_array=( "${path}"/* )
    # 打印所有文件路径
    for file in "${file_array[@]}"; do
        if [[ -f "$file" ]]; then
            body="${body},$(basename "$file")"
        fi
    done
    release_body="${release_body}  -------  ${body}"
}



#上传路径中所有文件
postPathAllFile(){
    local path=$1
    
    local headers=(
        "-H" "Authorization: Bearer ${github_tt}"
        "-H" "Accept: application/vnd.github.v3+json"
    )
    
    local pathName="$(basename "$path")"
    
    # 获取文件列表
    local file_array=( "${path}"/* )

    # 打印所有文件路径
    for file in "${file_array[@]}"; do
        if [[ -f "$file" ]]; then

            local mime_type=$(file -b --mime-type "$file")

            #文件名
            local fileName="${pathName}_$(basename "$file")"
            echo "查看 fileName：${fileName}"
            
            # 上传文件到 Release
            local upload_url="https://uploads.github.com/repos/${github_owner}/${github_repo}/releases/${release_id}/assets?name=${fileName}"
            headers+=("-H" "Content-Type: ${mime_type}")
            local response=$(curl -i -X POST "${headers[@]}" --data-binary "@${file}" "${upload_url}")

            echo "查看 response：${response}"
            echo "查看 upload_url：${upload_url}"
            echo "${file} 文件已添加到 GitHub Release！"

        fi
    done
}




# 遍历数组
for path in "${path_array[@]}"; do
    #调用函数，拼接body
    getFileNameInPath "$path"
done


# 创建新 Release
release_url="https://api.github.com/repos/${github_owner}/${github_repo}/releases"
headers=(
  "-H" "Authorization: Bearer ${github_tt}"
  "-H" "Accept: application/vnd.github.v3+json"
)
data="{\"tag_name\": \"${release_tag}\", \"name\": \"${release_name}\", \"body\": \"${release_body}\"}"
response=$(curl -s "${headers[@]}" -d "${data}" "${release_url}")
release_id=$(echo "${response}" | jq -r '.id')

echo "查看 release_id：${release_id}"



# 遍历数组
for path in "${path_array[@]}"; do
    #调用函数，上传文件
    postPathAllFile "$path"
done




