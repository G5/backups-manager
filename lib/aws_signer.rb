class AWSSigner

  def initialize(params)
    @params = params
    @now =  Time.now.utc
  end

  def upload_headers
    {
      acl: 'public-read',
      awsaccesskeyid: ENV['AWS_ACCESS_KEY_ID'],
      bucket: bucket,
      region: region,
      expires: @now + 10.hours,
      key: "#{sluggify_filename}",
      policy: policy,
      signature: upload_signature,
      success_action_status: '201',
      'Content-Type' => @params[:type],
      'Cache-Control' => 'max-age=630720000, public'
    }
  end

  def delete_headers
    {
      signature: delete_signature(@now),
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      success_action_status: '201',
      iso8601_date: iso8601_datetime(@now),
      simple_date: simple_date(@now),
      region: region
    }
  end

private

  def iso8601_datetime(datetime)
    datetime.strftime("%Y%m%dT%H%M%SZ")
  end

  def simple_date(datetime)
    datetime.strftime("%Y%m%d")
  end

  def delete_signature(datetime)
    Digest::hexencode(hmac_sha256(signing_key, string_to_sign(datetime)))
  end

  def string_to_sign(datetime)
    "AWS4-HMAC-SHA256\n"\
     "#{iso8601_datetime(datetime)}\n"\
     "#{simple_date(datetime)}/#{region}/s3/aws4_request\n"\
     "#{sha256(canonical_request(datetime))}"
  end

  def canonical_request(datetime)
    "DELETE\n"\
    "/#{bucket}/#{sluggify_filename}\n"\
    "\n"\
    "host:s3-#{region}.amazonaws.com\n"\
    "x-amz-date:#{iso8601_datetime(datetime)}\n"\
    "\n"\
    "host;x-amz-date\n"\
    "#{empty_string_sha256}"
  end

  def empty_string_sha256
    "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  end

  def region
    ENV['AWS_REGION']
  end

  def signing_key
    k_secret = ENV['AWS_SECRET_ACCESS_KEY']
    k_date = hmac_sha256("AWS4" + k_secret, @now.strftime("%Y%m%d"))
    k_region = hmac_sha256(k_date, region)
    k_service = hmac_sha256(k_region, "s3")
    k_signing = hmac_sha256(k_service, "aws4_request")
  end

  def hmac_sha256(key, input)
    OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, input)
  end

  def sha256(input)
    OpenSSL::Digest::SHA256.new(input).to_s
  end

  def policy(options = {})
    Base64.encode64(
      {
        expiration: @now + 10.hours,
        conditions: [
          { bucket: bucket },
          { acl: 'public-read' },
          { expires: @now + 10.hours },
          { success_action_status: '201' },
          [ 'starts-with', '$key', '' ],
          [ 'starts-with', '$Content-Type', '' ],
          [ 'starts-with', '$Cache-Control', '' ],
          [ 'content-length-range', 0, 524288000 ]
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end

  def bucket
    @bucket_name ||=  ENV['S3_BUCKET_NAME']
  end

  def upload_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'),
        ENV['AWS_SECRET_ACCESS_KEY'],
        policy({ secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] })
      )
    ).gsub(/\n/, '')
  end

  def sluggify_filename
    @params[:name].split('.').map {|part| part.parameterize}.join('.')
  end
end

