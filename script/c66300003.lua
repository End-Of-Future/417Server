--烈火战神出击！
local m=66300003
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66300003,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,66300003)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c66300003.thcon)
	e2:SetTarget(c66300003.thtg)
	e2:SetOperation(c66300003.thop)
	c:RegisterEffect(e2)
end

function cm.rfilter1(c,e,tp)
	return c:IsSetCard(0xaabb)
end

function cm.rfilter2(c,e,tp)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0xaabb) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

function cm.cfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsReleasableByEffect() and not c:IsCode(66300003)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.cfilter,tp,0x08,0,nil,e)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,0x12,0,1,nil,cm.rfilter1,e,tp,mg1,nil,Card.GetLevel,"Equal")
			or (mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(cm.rfilter2,tp,0x12,0,1,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(cm.cfilter,tp,0x08,0,nil,e)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,0x12,0,nil,cm.rfilter1,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local g2=nil
	local g=g1
	if mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g2=Duel.GetMatchingGroup(cm.rfilter2,tp,0x12,0,nil,e,tp)
		g=g1+g2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if g1:IsContains(tc) and (not g2 or (g2:IsContains(tc) and not Duel.SelectYesNo(tp,aux.Stringid(m,0)))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg2:Select(tp,1,1,nil)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end

function c66300003.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaabb)
end
function c66300003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c66300003.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66300003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c66300003.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end