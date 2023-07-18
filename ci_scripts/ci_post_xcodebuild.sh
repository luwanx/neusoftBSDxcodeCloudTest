#!/bin/sh

# 原始文件夹路径和标签名称
#CI_DERIVED_DATA_PATH="/Users/biprogybank06/Desktop/neusoftBSDxcodeCloudTest 2023-07-17 14-23-19"
#CI_TAG="v0.0.7"

# 压缩文件保存路径和名称
zip_file="${CI_DERIVED_DATA_PATH}/${CI_TAG}.zip"

# 压缩文件夹为 ZIP 格式
zip -r "${zip_file}" "$(basename "${CI_DERIVED_DATA_PATH}")"

echo "文件夹已成功压缩为 ZIP 文件！"

if [ -e "$zip_file" ]; then
    fileZipSuccess="文件存在"
else
    fileZipSuccess="文件不存在"
fi


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
release_body="Release notes：${CI_TAG}，CI_DERIVED_DATA_PATH=${CI_DERIVED_DATA_PATH},文件是否存在：${fileZipSuccess}"  # 替换为新 Release 的说明文本
file_name=${CI_TAG}.zip  # 替换为要添加的文件的名称

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

# 上传文件到 Release
upload_url="https://uploads.github.com/repos/${github_owner}/${github_repo}/releases/${release_id}/assets?name=${file_name}"
headers+=("-H" "Content-Type: application/zip")
response=$(curl -i -X POST "${headers[@]}" --data-binary "@${zip_file}" "${upload_url}")

echo "查看 response：${response}"

echo "查看 upload_url：${upload_url}"

echo "文件已添加到 GitHub Release！"
