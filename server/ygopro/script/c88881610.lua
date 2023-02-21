--星焰机 散落星辰的律理兵械
function c88881610.initial_effect(c)
	aux.AddXyzProcedure(c,nil,12,2,c88881610.ovfilter,aux.Stringid(88881610,0),2,c88881610.xyzop)
	c:EnableReviveLimit()

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(aux.xyzlimit)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88881610,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c88881610.tgcost)
	e1:SetTarget(c88881610.tgtg)
	e1:SetOperation(c88881610.tgop)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88881610,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,88881610)
	e3:SetCondition(c88881610.regcon)
	e3:SetOperation(c88881610.regop)
	c:RegisterEffect(e3)
	if not c88881610.global_check then
		c88881610.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c88881610.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
end
function c88881610.ovfilter(c)
	return c:IsFaceup() and c:IsRankAbove(10) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ)
end
function c88881610.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,88881610)>0 and Duel.GetFlagEffect(tp,9875080)==0 end
	Duel.RegisterFlagEffect(tp,9875080,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c88881610.check(c)
	return c and c:IsType(TYPE_XYZ)
end
function c88881610.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c88881610.check(Duel.GetAttacker()) or c88881610.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,88881610,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,88881610,RESET_PHASE+PHASE_END,0,1)
	end
end
function c88881610.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c88881610.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c88881610.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c88881610.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c88881610.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c88881610.spcon)
	e1:SetOperation(c88881610.spop)
	if Duel.GetCurrentPhase()<=PHASE_END then
		e1:SetReset(RESET_PHASE+PHASE_END,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END)
	end
	Duel.RegisterEffect(e1,tp)
end
function c88881610.spfilter(c,e,tp)
	return c:IsCode(88881610) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88881610.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88881610.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c88881610.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,88881610)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88881610.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local g1=Duel.SelectMatchingCard(tp,c88881610.mtfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(c,g1)
	end
end
function c88881610.mtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and c:IsLevelAbove(10) and c:IsCanOverlay() and not c:IsCode(88881610)
end