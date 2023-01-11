--控制死灵
function c8527941.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,8527941)
	e1:SetTarget(c8527941.tftg)
	e1:SetOperation(c8527941.tfop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,8527942)
	e3:SetTarget(c8527941.dgtg)
	e3:SetOperation(c8527941.dgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c8527941.damop)
	c:RegisterEffect(e4)
end
function c8527941.tffi(c)
	return (c:IsSetCard(0xa9a) or c:IsCode(98139712)) and (c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c8527941.tftg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8527941.tffi,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c8527941.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.GetMatchingGroup(c8527941.tffi,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c8527941.dgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,6,PLAYER_ALL,LOCATION_DECK)
end
function c8527941.dgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<0
		or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<0 then return end
	local ga=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local gb=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ag=ga:RandomSelect(nil,3)
	local bg=gb:RandomSelect(nil,3)
	Duel.SendtoGrave(ag,REASON_EFFECT)
	Duel.SendtoGrave(bg,REASON_EFFECT)
end
function c8527941.fi1(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetOwner()==tp
end
function c8527941.fi2(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetOwner()==1-tp
end
function c8527941.damop(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c8527941.fi1,nil,tp)*100
	local d2=eg:FilterCount(c8527941.fi2,nil,tp)*100
	Duel.Damage(tp,d1,REASON_EFFECT)
	Duel.Damage(1-tp,d2,REASON_EFFECT)
end
