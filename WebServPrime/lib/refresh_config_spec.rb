require ('refresh_config')

describe('#refresh_config?') do
  it("Error: wrong directory") do
    expect(refresh_config?).to(eq(false))
  end
  it("Success") do
    expect(refresh_config?).to(eq(false))
  end
end 
