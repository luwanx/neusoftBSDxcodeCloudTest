#!/bin/sh

# 原始文件夹路径和标签名称
CI_DERIVED_DATA_PATH="/Users/biprogybank06/Desktop/neusoftBSDxcodeCloudTest2023-07-1714-23-19"
CI_TAG="v0.0.2"

# 获取文件夹的上级路径
parent_path=$(dirname "${CI_DERIVED_DATA_PATH}")

# 压缩文件保存路径和名称
zip_file="${parent_path}/${CI_TAG}.zip"

# 压缩文件夹为 ZIP 格式
cd "${parent_path}" || exit 1
zip -r "${zip_file}" "$(basename "${CI_DERIVED_DATA_PATH}")"

echo "文件夹已成功压缩为 ZIP 文件！"

# GitHub 认证信息
github_token="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"  # 替换为你的 GitHub Personal Access Token
github_owner="luwanx"  # 替换为 GitHub 仓库的所有者用户名
github_repo="neusoftBSDxcodeCloudTest"  # 替换为 GitHub 仓库的名称

# Release 信息
release_tag=${CI_TAG}  # 替换为新 Release 的标签
release_name="Release${CI_TAG}"  # 替换为新 Release 的名称
release_body="Release notes${CI_TAG}"  # 替换为新 Release 的说明文本
file_name=${CI_TAG}.zip  # 替换为要添加的文件的名称

# 创建新 Release
release_url="https://api.github.com/repos/${github_owner}/${github_repo}/releases"
headers=(
  "-H" "Authorization: Bearer ${github_token}"
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
