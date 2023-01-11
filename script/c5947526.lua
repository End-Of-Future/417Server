--侍从死灵
function c5947526.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,5947526)
	e1:SetTarget(c5947526.sstg)
	e1:SetOperation(c5947526.ssop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,5947527)
	e3:SetTarget(c5947526.egtg)
	e3:SetOperation(c5947526.egop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c5947526.damop)
	c:RegisterEffect(e4)
end
function c5947526.ssfi(c)
	return c:IsSetCard(0xa9a) and c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c5947526.sstg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5947526.ssfi,tp,LOCATION_DECK,0,1,nil)
end
function c5947526.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c5947526.ssfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
function c5947526.egtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_HAND)
end
function c5947526.egop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<0
		or Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_EXTRA,0,1,1,nil)
	if tg:GetCount()>0 then
	   Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
	   Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c5947526.fi1(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:GetOwner()==tp
end
function c5947526.fi2(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:GetOwner()==1-tp
end
function c5947526.damop(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c5947526.fi1,nil,tp)*100
	local d2=eg:FilterCount(c5947526.fi2,nil,tp)*100
	Duel.Damage(tp,d1,REASON_EFFECT)
	Duel.Damage(1-tp,d2,REASON_EFFECT)
end
