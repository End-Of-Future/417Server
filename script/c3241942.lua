--侍从死灵
function c3241942.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3241942)
	e1:SetTarget(c3241942.sptg)
	e1:SetOperation(c3241942.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,3241943)
	e3:SetTarget(c3241942.dctg)
	e3:SetOperation(c3241942.dcop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c3241942.damop)
	c:RegisterEffect(e4)
end
function c3241942.spfi(c,e,tp)
	return c:IsSetCard(0xa9a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,0,0) and not c:IsCode(3241942)
end
function c3241942.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3241942.spfi,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c3241942.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3241942.spfi,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,0,0,POS_FACEUP)
	end
end
function c3241942.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,PLAYER_ALL,LOCATION_HAND)
end
function c3241942.dcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<0
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<0 then return end
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
end
function c3241942.fi1(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:GetOwner()==tp
end
function c3241942.fi2(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:GetOwner()==1-tp
end
function c3241942.damop(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c3241942.fi1,nil,tp)*100
	local d2=eg:FilterCount(c3241942.fi2,nil,tp)*100
	Duel.Damage(tp,d1,REASON_EFFECT)
	Duel.Damage(1-tp,d2,REASON_EFFECT)
end
